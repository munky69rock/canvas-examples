FPS = 30
SCREEN_SIZE = 500
NUM_BOIDS = 100
BOID_SIZE = 5
MAX_SPPED = 7

canvas = document.getElementById 'world'
ctx = canvas.getContext '2d'
boids = []

window.onload = ->
  canvas.width = canvas.height = SCREEN_SIZE
  ctx.fillStyle = 'rgba(33,33,33,0.8)'
  for i in [0 ... NUM_BOIDS]
    boids[i] =
      x: Math.random()*SCREEN_SIZE
      y: Math.random()*SCREEN_SIZE
      vx: 0
      vy: 0

  setInterval simulate, 1000/FPS
  return
    
simulate = ->
  draw()
  move()

draw = ->
  ctx.clearRect(0,0,SCREEN_SIZE,SCREEN_SIZE)
  for i in [0 ... boids.length]
    ctx.fillRect(boids[i].x - BOID_SIZE/2, boids[i].y - BOID_SIZE/2, BOID_SIZE, BOID_SIZE)

move = ->
  for i in [0 ... boids.length]
    rule1(i)
    rule2(i)
    rule3(i)
    
    b = boids[i]
    speed = Math.sqrt(Math.pow(b.vx, 2) + Math.pow(b.vy, 2))
    if speed >= MAX_SPPED
      r = MAX_SPPED / speed
      b.vx *= r
      b.vy *= r

    b.vx *= -1 if (b.x < 0 and b.vx < 0) or (b.x > SCREEN_SIZE and b.vx > 0)
    b.vy *= -1 if (b.y < 0 and b.vy < 0) or (b.y > SCREEN_SIZE and b.vy > 0)

    b.x += b.vx
    b.y += b.vy

rule1 = (index) ->
  c = x:0, y:0
  for i in [0 ... boids.length] when i isnt index
    c.x += boids[i].x
    c.y += boids[i].y

  c.x /= boids.length - 1
  c.y /= boids.length - 1

  boids[index].vx += (c.x - boids[index].x) / 100
  boids[index].vy += (c.y - boids[index].y) / 100

rule2 = (index) ->
  for i in [0 ... boids.length] when i isnt index
    d = getDistance(boids[i], boids[index])
    if d < 5
      boids[index].vx -= boids[i].x - boids[index].x
      boids[index].vy -= boids[i].y - boids[index].y

rule3 = (index) ->
  pv = x:0, y:0
  for i in [0 ... boids.length] when i isnt index
    pv.x += boids[i].vx
    pv.y += boids[i].vy

  pv.x /= boids.length - 1
  pv.y /= boids.length - 1

  boids[index].vx += (pv.x - boids[index].vx)/8
  boids[index].vy += (pv.y - boids[index].vy)/8

getDistance = (b1, b2) ->
  x = b1.x - b2.x
  y = b1.y - b2.y
  return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2))
