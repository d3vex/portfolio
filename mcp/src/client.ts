/**
 * Thin REST client for the CV Portfolio backend API.
 * Handles JWT auth (login → token) and 401 retry-once.
 */

import type { Config } from "./config.js";

export interface LoginResponse {
  access_token: string;
  user: { id: string; username: string; role: string };
}

export interface ApiResponse {
  status: number;
  data: unknown;
}

export class ApiClient {
  private token: string | null = null;
  private loggingIn = false;

  constructor(private readonly cfg: Config) {}

  /** Ensure we have a valid token, logging in if needed. */
  async ensureAuth(): Promise<string> {
    if (this.token) return this.token;
    await this.login();
    return this.token!;
  }

  async login(): Promise<void> {
    this.loggingIn = true;
    try {
      const res = await fetch(`${this.cfg.baseUrl}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username: this.cfg.username,
          password: this.cfg.password,
        }),
      });

      if (!res.ok) {
        const body = await safeJson(res);
        throw new Error(`Login failed (${res.status}): ${JSON.stringify(body)}`);
      }

      const data = (await res.json()) as LoginResponse;
      this.token = data.access_token;
    } finally {
      this.loggingIn = false;
    }
  }

  /** Perform an authenticated request. On 401, re-login once and retry. */
  async request(
    method: "GET" | "POST" | "PATCH" | "DELETE",
    path: string,
    body?: unknown,
  ): Promise<ApiResponse> {
    const attempt = async (retryOn401: boolean): Promise<ApiResponse> => {
      const token = await this.ensureAuth();
      const headers: Record<string, string> = {
        Authorization: `Bearer ${token}`,
      };
      if (body !== undefined) {
        headers["Content-Type"] = "application/json";
      }

      const res = await fetch(`${this.cfg.baseUrl}${path}`, {
        method,
        headers,
        body: body !== undefined ? JSON.stringify(body) : undefined,
      });

      if (res.status === 401 && retryOn401 && !this.loggingIn) {
        this.token = null;
        await this.login();
        return attempt(false);
      }

      const data = await safeJson(res);
      return { status: res.status, data };
    };

    return attempt(true);
  }
}

async function safeJson(res: Response): Promise<unknown> {
  try {
    return await res.json();
  } catch {
    return null;
  }
}
