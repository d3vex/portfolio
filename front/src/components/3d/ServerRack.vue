<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

type ServerStatus = 'online' | 'failing' | 'restarting'

interface ServerSlot {
  id: number
  label: string
  status: ServerStatus
  progress: number
  blink: boolean
}

interface Particle {
  id: number
  serverId: number
  x: number
  y: number
  angle: number
  speed: number
  size: number
  color: string
  life: number
  maxLife: number
}

const servers = ref<ServerSlot[]>([])
const particles = ref<Particle[]>([])
const rackRef = ref<HTMLDivElement>()

let failureTimer: ReturnType<typeof setTimeout> | null = null
let animFrame: number | null = null
let partFrame: number | null = null
let nextParticleId = 0

onMounted(() => {
  servers.value = Array.from({ length: 8 }, (_, i) => ({
    id: i,
    label: `SRV-${String(i + 1).padStart(2, '0')}`,
    status: 'online',
    progress: 1,
    blink: false,
  }))
  updateParticles()
  scheduleFailure()
})

onUnmounted(() => {
  if (failureTimer) clearTimeout(failureTimer)
  if (animFrame) cancelAnimationFrame(animFrame)
  if (partFrame) cancelAnimationFrame(partFrame)
})

function pickRandomOnline(): ServerSlot | null {
  const online = servers.value.filter(s => s.status === 'online')
  return online.length ? online[Math.floor(Math.random() * online.length)] : null
}

function scheduleFailure() {
  const delay = 3000 + Math.random() * 6000
  failureTimer = setTimeout(() => {
    const target = pickRandomOnline()
    if (target) startFailure(target)
    else scheduleFailure()
  }, delay)
}

function spawnParticles(srv: ServerSlot, count: number) {
  const rack = rackRef.value
  if (!rack) return
  const srvEl = rack.querySelector(`[data-srv-id="${srv.id}"]`) as HTMLElement | null
  if (!srvEl) return
  const rackRect = rack.getBoundingClientRect()
  const srvRect = srvEl.getBoundingClientRect()
  const cx = srvRect.left - rackRect.left + srvRect.width / 2
  const cy = srvRect.top - rackRect.top + srvRect.height / 2

  const colors = ['#ef4444', '#dc2626', '#f97316', '#fbbf24', '#fff']
  for (let i = 0; i < count; i++) {
    particles.value.push({
      id: nextParticleId++,
      serverId: srv.id,
      x: cx + (Math.random() - 0.5) * 20,
      y: cy + (Math.random() - 0.5) * 10,
      angle: Math.random() * Math.PI * 2,
      speed: 60 + Math.random() * 160,
      size: 2 + Math.random() * 5,
      color: colors[Math.floor(Math.random() * colors.length)],
      life: 0,
      maxLife: 0.6 + Math.random() * 1.0,
    })
  }
}

function startFailure(srv: ServerSlot) {
  srv.status = 'failing'
  srv.progress = 0
  const duration = 2800
  const start = performance.now()
  let lastSpawn = 0

  function frame(now: number) {
    const t = Math.min((now - start) / duration, 1)
    srv.progress = t

    if (t < 0.25) {
      srv.blink = Math.sin(t * 50) > 0
    } else if (t < 0.55) {
      srv.blink = Math.sin(t * 35 + 2) > 0.2
    } else if (t < 0.8) {
      srv.blink = Math.sin(t * 15 + 5) > 0.4
    } else {
      srv.blink = false
    }

    // Spawn particles during first 60% of failure
    if (t < 0.6 && now - lastSpawn > 60) {
      spawnParticles(srv, 2 + Math.floor(Math.random() * 3))
      lastSpawn = now
    }

    if (t < 1) {
      animFrame = requestAnimationFrame(frame)
    } else {
      srv.progress = -1
      srv.blink = false
      setTimeout(() => startRestart(srv), 5000)
    }
  }
  animFrame = requestAnimationFrame(frame)
}

function startRestart(srv: ServerSlot) {
  srv.status = 'restarting'
  srv.progress = 0
  const duration = 5000
  const start = performance.now()

  function frame(now: number) {
    const t = Math.min((now - start) / duration, 1)
    srv.progress = t

    if (t < 0.08) {
      srv.blink = Math.floor(now / 180) % 2 === 0
    } else if (t < 0.22) {
      srv.blink = Math.sin(t * 45) > 0
    } else if (t < 0.68) {
      srv.blink = Math.sin(t * 12 + 3) > 0.15
    } else {
      srv.blink = Math.sin(t * 28 + 7) > 0.65
    }

    if (t < 1) {
      animFrame = requestAnimationFrame(frame)
    } else {
      srv.status = 'online'
      srv.progress = 1
      srv.blink = false
      scheduleFailure()
    }
  }
  animFrame = requestAnimationFrame(frame)
}

function updateParticles() {
  partFrame = requestAnimationFrame(updateParticles)

  if (particles.value.length === 0) return

  const dt = 0.016
  const toRemove = new Set<number>()

  for (const p of particles.value) {
    p.life += dt
    p.x += Math.cos(p.angle) * p.speed * dt
    p.y += Math.sin(p.angle) * p.speed * dt
    p.speed *= 0.97
    if (p.life >= p.maxLife) {
      toRemove.add(p.id)
    }
  }

  if (toRemove.size > 0) {
    particles.value = particles.value.filter(p => !toRemove.has(p.id))
  }
}

function activityHeight(srv: ServerSlot, barIdx: number): string {
  if (srv.status === 'online') {
    const heights = [40, 70, 55]
    return `${heights[barIdx]}%`
  }
  if (srv.status === 'failing') {
    const factor = 1 - srv.progress
    if (srv.progress > 0.6) return '5%'
    if (srv.progress < 0) return '0%'
    return `${15 + factor * ((barIdx + 1) * 15 + 20)}%`
  }
  if (srv.status === 'restarting') {
    return `${10 + srv.progress * ((barIdx + 1) * 15 + 20)}%`
  }
  return '40%'
}

function barOpacity(srv: ServerSlot): number {
  if (srv.status === 'online') return 1
  if (srv.status === 'failing') {
    if (srv.progress < 0) return 0
    if (srv.progress > 0.7) return 0.1
    return Math.max(0, 1 - srv.progress)
  }
  if (srv.status === 'restarting') return Math.min(1, srv.progress * 2)
  return 1
}

function barColor(srv: ServerSlot): string {
  if (srv.status === 'failing') return '#ef4444'
  if (srv.status === 'restarting') return '#eab308'
  return '#22c55e'
}

function statusText(srv: ServerSlot): string {
  if (srv.status === 'failing') {
    if (srv.progress < 0.15) return 'ERR!'
    if (srv.progress < 0.35) return 'CRIT'
    if (srv.progress < 0.6) return 'DOWN'
    return 'OFF'
  }
  if (srv.status === 'restarting') {
    if (srv.progress < 0.1) return 'INIT'
    if (srv.progress < 0.4) return 'POST'
    if (srv.progress < 0.75) return 'BOOT'
    return 'SYNC'
  }
  return ''
}

function statusClass(srv: ServerSlot): string {
  if (srv.status === 'failing') return 'status--fail'
  if (srv.status === 'restarting') return 'status--reboot'
  return ''
}

function slotEl(srv: ServerSlot): string {
  if (srv.status === 'restarting') return 'slot--restarting'
  return ''
}
</script>

<template>
  <div ref="rackRef" class="server-rack">
    <div class="rack-header">
      <div class="header-dots">
        <span class="dot dot--green" />
        <span class="dot dot--blue" />
        <span class="dot dot--amber" />
      </div>
      <span class="header-label">D3VEX-DATACENTER-01</span>
      <span class="header-status">ALL SYSTEMS NOMINAL</span>
    </div>

    <div class="rack-body">
      <div
        v-for="srv in servers"
        :key="srv.id"
        class="slot"
        :class="[slotEl(srv)]"
      >
        <div class="ear" />
        <div class="server" :class="statusClass(srv)" :data-srv-id="srv.id">
          <div class="server__indicator">
            <span
              class="server__led server__led--power"
              :class="{
                green: srv.status === 'online',
                red: srv.status === 'failing',
                yellow: srv.status === 'restarting',
                blink: srv.blink
              }"
            />
            <span
              class="server__led server__led--act"
              :class="{
                green: srv.status === 'online',
                red: srv.status === 'failing',
                yellow: srv.status === 'restarting',
                blink: srv.blink
              }"
            />
          </div>

          <span class="server__label">{{ srv.label }}</span>

          <div class="server__bars">
            <span
              v-for="n in 3"
              :key="n"
              class="server__bar"
              :class="{ 'server__bar--online': srv.status === 'online' }"
              :style="{
                height: activityHeight(srv, n - 1),
                opacity: barOpacity(srv),
                background: barColor(srv),
              }"
            />
          </div>

          <div v-if="srv.status === 'online'" class="server__traffic">
            <span class="traffic-dot" />
          </div>

          <span
            v-if="srv.status !== 'online'"
            class="server__status-tag"
            :class="statusClass(srv)"
          >
            {{ statusText(srv) }}
          </span>

          <div v-if="srv.status === 'online'" class="server__online-ring" />
        </div>
        <div class="ear" />
      </div>
    </div>

    <div class="rack-footer">
      <div class="vent-slits">
        <span v-for="n in 20" :key="n" class="slit" />
      </div>
    </div>

    <div class="particles-layer">
      <div
        v-for="p in particles"
        :key="p.id"
        class="particle"
        :style="{
          left: `${p.x}px`,
          top: `${p.y}px`,
          width: `${p.size}px`,
          height: `${p.size}px`,
          background: p.color,
          opacity: 1 - p.life / p.maxLife,
        }"
      />
    </div>
  </div>
</template>

<style scoped>
.server-rack {
  width: 100%;
  background: linear-gradient(180deg, #141418 0%, #18181c 100%);
  border: 1px solid #2a2a32;
  border-radius: 8px;
  overflow: visible;
  position: relative;
}

.rack-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 14px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(255, 255, 255, 0.02);
}
.header-dots {
  display: flex;
  gap: 5px;
}
.dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
}
.dot--green { background: #22c55e; }
.dot--blue { background: #3b82f6; }
.dot--amber { background: #f59e0b; }
.header-label {
  font-size: 10px;
  font-family: monospace;
  color: rgba(255, 255, 255, 0.2);
  letter-spacing: 0.08em;
}
.header-status {
  margin-left: auto;
  font-size: 9px;
  font-family: monospace;
  color: #22c55e;
  opacity: 0.6;
  letter-spacing: 0.1em;
}

.rack-body {
  padding: 6px 10px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  position: relative;
}

.slot {
  display: flex;
  align-items: stretch;
  height: 34px;
  border-radius: 4px;
  overflow: visible;
  position: relative;
}
.slot::before {
  content: '';
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 4px;
  pointer-events: none;
  z-index: 0;
}
.slot--restarting::before {
  background: rgba(234, 179, 8, 0.04);
}

.ear {
  width: 8px;
  background: linear-gradient(180deg, #25252c, #1c1c22);
  border-radius: 2px;
  position: relative;
  z-index: 1;
}
.ear::after {
  content: '';
  position: absolute;
  width: 2px;
  height: 2px;
  background: #3a3a44;
  border-radius: 50%;
  top: 4px;
  left: 50%;
  transform: translateX(-50%);
  box-shadow: 0 10px 0 #3a3a44;
}

.server {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 10px;
  background: linear-gradient(90deg, #22222a 0%, #27272e 50%, #22222a 100%);
  border: 1px solid rgba(255, 255, 255, 0.04);
  position: relative;
  z-index: 1;
  transition: border-color 0.3s, box-shadow 0.3s;
}
.server.status--fail {
  border-color: rgba(239, 68, 68, 0.3);
  box-shadow: inset 0 0 25px rgba(239, 68, 68, 0.06);
  animation: fail-pulse 0.3s ease infinite alternate;
}
.server.status--reboot {
  border-color: rgba(234, 179, 8, 0.2);
  box-shadow: inset 0 0 20px rgba(234, 179, 8, 0.04);
}

.server__online-ring {
  position: absolute;
  inset: -1px;
  border-radius: 3px;
  border: 1px solid rgba(34, 197, 94, 0.06);
  animation: breathe 2.5s ease-in-out infinite;
  pointer-events: none;
}

.server__indicator {
  display: flex;
  gap: 4px;
}
.server__led {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #0a0a0c;
  border: 1px solid #1e1e24;
  transition: background 0.1s, box-shadow 0.1s;
}
.server__led.green {
  background: #22c55e;
  box-shadow: 0 0 5px rgba(34, 197, 94, 0.5);
  animation: breathe 2s ease-in-out infinite;
}
.server__led.red {
  background: #ef4444;
  box-shadow: 0 0 8px rgba(239, 68, 68, 0.6);
}
.server__led.yellow {
  background: #eab308;
  box-shadow: 0 0 6px rgba(234, 179, 8, 0.5);
}

.server__label {
  font-size: 10px;
  font-family: monospace;
  color: rgba(255, 255, 255, 0.45);
  letter-spacing: 0.05em;
  min-width: 48px;
}

.server__bars {
  display: flex;
  align-items: flex-end;
  gap: 2px;
  height: 16px;
  flex: 1;
  max-width: 100px;
}
.server__bar {
  width: 4px;
  border-radius: 1px 1px 0 0;
  transition: height 0.15s ease, opacity 0.15s ease, background 0.15s ease;
}
.server__bar--online {
  animation: bar-bounce 1.2s ease-in-out infinite;
}
.server__bar--online:nth-child(1) { animation-delay: 0s; }
.server__bar--online:nth-child(2) { animation-delay: 0.15s; }
.server__bar--online:nth-child(3) { animation-delay: 0.3s; }

.server__traffic {
  display: flex;
  align-items: center;
}
.traffic-dot {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: #22c55e;
  opacity: 0.6;
  animation: blink 1.5s ease-in-out infinite;
}

.server__status-tag {
  font-size: 8px;
  font-family: monospace;
  font-weight: bold;
  letter-spacing: 0.12em;
  padding: 1px 5px;
  border-radius: 2px;
  animation: pulse-tag 0.5s ease infinite alternate;
}
.server__status-tag.status--fail {
  color: #ef4444;
  background: rgba(239, 68, 68, 0.12);
  border: 1px solid rgba(239, 68, 68, 0.3);
  animation: pulse-tag 0.15s ease infinite alternate;
}
.server__status-tag.status--reboot {
  color: #eab308;
  background: rgba(234, 179, 8, 0.08);
  border: 1px solid rgba(234, 179, 8, 0.2);
}

.rack-footer {
  padding: 6px 14px;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(0, 0, 0, 0.1);
}
.vent-slits {
  display: flex;
  gap: 3px;
}
.slit {
  flex: 1;
  height: 10px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.02);
  border-radius: 1px;
}

.particles-layer {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: visible;
  z-index: 10;
}
.particle {
  position: absolute;
  border-radius: 50%;
  pointer-events: none;
  will-change: transform, opacity;
}

@keyframes breathe {
  0%, 100% { opacity: 0.6; }
  50% { opacity: 1; }
}

@keyframes bar-bounce {
  0%, 100% { transform: scaleY(0.85); }
  50% { transform: scaleY(1.15); }
}

@keyframes blink {
  0%, 100% { opacity: 0.3; }
  50% { opacity: 0.8; }
}

@keyframes pulse-tag {
  from { opacity: 0.7; }
  to { opacity: 1; }
}

@keyframes fail-pulse {
  from { box-shadow: inset 0 0 20px rgba(239, 68, 68, 0.04); }
  to { box-shadow: inset 0 0 30px rgba(239, 68, 68, 0.1); }
}
</style>
