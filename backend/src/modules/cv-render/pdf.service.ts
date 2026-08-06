import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { execSync } from 'child_process';
import { existsSync } from 'fs';
import puppeteer, { Browser } from 'puppeteer';

type LaunchOptions = Parameters<typeof puppeteer.launch>[0];

const SYSTEM_CHROME_BINARIES = [
  'google-chrome',
  'google-chrome-stable',
  'chromium',
  'chromium-browser',
];

@Injectable()
export class PdfService implements OnModuleDestroy {
  private browser: Browser | null = null;
  private launchPromise: Promise<Browser> | null = null;
  private shuttingDown = false;

  constructor() {
    const close = () => {
      void this.closeBrowser();
    };
    // NestJS does not call enableShutdownHooks in main.ts, so register the
    // process handlers directly to make sure the browser is closed on exit.
    process.once('SIGINT', close);
    process.once('SIGTERM', close);
  }

  async render(html: string): Promise<Buffer> {
    const browser = await this.getBrowser();
    const page = await browser.newPage();
    try {
      await page.setContent(html, { waitUntil: 'load' });
      await page.emulateMediaType('print');
      // Google Fonts load asynchronously after `load`; wait for the font faces
      // to settle so the PDF uses the intended typefaces.
      await page.evaluate(() => document.fonts.ready);
      return Buffer.from(
        await page.pdf({
          format: 'A4',
          printBackground: true,
          preferCSSPageSize: false,
        }),
      );
    } finally {
      await page.close();
    }
  }

  async onModuleDestroy(): Promise<void> {
    await this.closeBrowser();
  }

  private async getBrowser(): Promise<Browser> {
    if (this.shuttingDown) {
      throw new Error('PdfService is shutting down, cannot start a new render');
    }
    if (!this.launchPromise) {
      this.launchPromise = this.launch().catch((error: unknown) => {
        this.launchPromise = null;
        throw error;
      });
    }
    return this.launchPromise;
  }

  private async launch(): Promise<Browser> {
    const options: LaunchOptions = {
      args: ['--no-sandbox', '--disable-setuid-sandbox'],
    };
    const executablePath = await this.resolveExecutablePath();
    if (executablePath) {
      options.executablePath = executablePath;
    }
    const browser = await puppeteer.launch(options);
    this.browser = browser;
    return browser;
  }

  private async resolveExecutablePath(): Promise<string | undefined> {
    // 1. Explicit override (also the puppeteer-core escape hatch).
    if (process.env.PUPPETEER_EXECUTABLE_PATH) {
      return process.env.PUPPETEER_EXECUTABLE_PATH;
    }
    // 2. Bundled Chromium (only exists when the `puppeteer` postinstall ran).
    try {
      const bundled = await puppeteer.executablePath();
      if (bundled && existsSync(bundled)) {
        return bundled;
      }
    } catch {
      // puppeteer-core or a stripped install — fall through to system Chrome.
    }
    // 3. System Chrome / Chromium.
    for (const binary of SYSTEM_CHROME_BINARIES) {
      try {
        const resolved = execSync(`command -v ${binary}`, { encoding: 'utf8' }).trim();
        if (resolved) {
          return resolved;
        }
      } catch {
        // binary not on PATH — try the next one
      }
    }
    return undefined;
  }

  private async closeBrowser(): Promise<void> {
    this.shuttingDown = true;
    const current = this.browser;
    this.browser = null;
    this.launchPromise = null;
    if (current) {
      await current.close().catch(() => undefined);
    }
  }
}
