import { ref, onMounted, onUnmounted, type Ref } from 'vue'

interface Particle {
  x: number
  y: number
  vx: number
  vy: number
  radius: number
  opacity: number
}

export function useParticles(canvasRef: Ref<HTMLCanvasElement | null>) {
  const particles = ref<Particle[]>([])
  let animationId: number | null = null
  let ctx: CanvasRenderingContext2D | null = null

  const PARTICLE_COUNT = 80
  const CONNECTION_DISTANCE = 150
  const PARTICLE_SPEED = 1.5

  function init() {
    if (!canvasRef.value) return
    ctx = canvasRef.value.getContext('2d')
    if (!ctx) return

    resize()
    window.addEventListener('resize', resize)

    particles.value = Array.from({ length: PARTICLE_COUNT }, () => ({
      x: Math.random() * (canvasRef.value?.width ?? window.innerWidth),
      y: Math.random() * (canvasRef.value?.height ?? window.innerHeight),
      vx: (Math.random() - 0.5) * PARTICLE_SPEED,
      vy: (Math.random() - 0.5) * PARTICLE_SPEED,
      radius: Math.random() * 2 + 1,
      opacity: Math.random() * 0.5 + 0.2,
    }))

    animate()
  }

  function resize() {
    if (!canvasRef.value) return
    canvasRef.value.width = window.innerWidth
    canvasRef.value.height = window.innerHeight
  }

  function animate() {
    if (!ctx || !canvasRef.value) return

    ctx.clearRect(0, 0, canvasRef.value.width, canvasRef.value.height)

    const isDark = document.documentElement.classList.contains('dark')

    particles.value.forEach((p, i) => {
      p.x += p.vx
      p.y += p.vy

      if (p.x < 0 || p.x > (canvasRef.value?.width ?? 0)) p.vx *= -1
      if (p.y < 0 || p.y > (canvasRef.value?.height ?? 0)) p.vy *= -1

      ctx!.beginPath()
      ctx!.arc(p.x, p.y, p.radius, 0, Math.PI * 2)
      ctx!.fillStyle = isDark ? `rgba(0, 255, 255, ${p.opacity})` : `rgba(37, 99, 235, ${p.opacity})`
      ctx!.fill()

      for (let j = i + 1; j < particles.value.length; j++) {
        const p2 = particles.value[j]!
        const dx = p.x - p2.x
        const dy = p.y - p2.y
        const dist = Math.sqrt(dx * dx + dy * dy)

        if (dist < CONNECTION_DISTANCE) {
          const alpha = (1 - dist / CONNECTION_DISTANCE) * 0.15
          ctx!.beginPath()
          ctx!.moveTo(p.x, p.y)
          ctx!.lineTo(p2.x, p2.y)
          ctx!.strokeStyle = isDark ? `rgba(0, 255, 255, ${alpha})` : `rgba(37, 99, 235, ${alpha})`
          ctx!.lineWidth = 0.5
          ctx!.stroke()
        }
      }
    })

    animationId = requestAnimationFrame(animate)
  }

  function destroy() {
    if (animationId !== null) {
      cancelAnimationFrame(animationId)
    }
    window.removeEventListener('resize', resize)
  }

  onMounted(() => init())
  onUnmounted(() => destroy())

  return { init, destroy }
}
