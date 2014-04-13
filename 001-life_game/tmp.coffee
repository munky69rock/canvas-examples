SCREEN_SIZE = 500
SIDE_CELLS = 200
CELL_SIZE = SCREEN_SIZE / SIDE_CELLS
FPS = 10

class Field extends Array
  constructor: ->
    for i in [0 ... SIDE_CELLS*SIDE_CELLS]
      @push Math.floor(Math.random()*2)
    
  clone: -> @slice()


class Canvas
  constructor: ->
    @cvs = document.getElementById @id
    @scaleRate = Math.min(window.innerWidth/SCREEN_SIZE, window.innerHeight/SCREEN_SIZE)
    for k in ['width', 'height']
      @cvs[k] = SCREEN_SIZE
      @cvs.style[k] = SCREEN_SIZE*@scaleRate + 'px'

    @ctx = @cvs.getContext '2d'
    @ctx.fillStyle = @style

  id: 'world'
  style: 'rgb(211,85,149)'

  draw: (field) ->
    @ctx.clearRect 0, 0, SCREEN_SIZE, SCREEN_SIZE
    for i in [0 ... field.length]
      x = (i % SIDE_CELLS) * CELL_SIZE
      y = Math.floor(i / SIDE_CELLS) * CELL_SIZE
      if field[i]
        @ctx.fillRect x, y, CELL_SIZE, CELL_SIZE
    return

class LifeGame
  constructor: ->
    @field = new Field()
    @canvas = new Canvas()

  field: []
  tempField: []
  canvas: null

  update: ->
    surviver = 0
    @tempField = @field.clone()
    for i in [0 ... @tempField.length]
      surviver = 0
      for s in [-1 .. 1]
        for t in [-1 .. 1]
          continue if s is 0 and t is 0
          c = i + s*SIDE_CELLS + t
          if c >= 0 and c < @tempField.length
            if (i < c and c % SIDE_CELLS isnt 0) or (i>c and c % SIDE_CELLS isnt SIDE_CELLS - 1)
              surviver++ if @tempField[c]
      if @tempField[i] and (surviver is 2 or surviver is 3)
        @field[i] = 1
      else if not @tempField[i] and surviver is 3
        @field[i] = 1
      else
        @field[i] = 0

    @canvas.draw(@field)
    self = @
    setTimeout ->
      self.update()
    , 1000/FPS
    

window.onload = ->
  lifeGame = new LifeGame()
  lifeGame.update()
  return
