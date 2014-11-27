app.service 'Renderer', ['$timeout', class Renderer
  constructor: (@$timeout) ->
    console.log("Renderer:Constructor")
    @render = false
    @framerate = 2
    @objects = []
    @tileSize0 = 10
    @zoom = 2.1
    @camera = [0, 0]
    @eventsRegister = {
      mousedown: [],
      mouseup: []
    }

    @tick()

  tileSize: =>
    @zoom * @tileSize0

  setCanvas: (@canvas) =>
    @canvas.context = @canvas[0].getContext('2d')
    @canvas.resolution = [@canvas[0].offsetWidth, window.innerHeight - @canvas[0].offsetTop - 10]

    @canvas[0].width  = @canvas.resolution[0]
    @canvas[0].height = @canvas.resolution[1]
    @canvas.tileSize = =>
      @tileSize()

    @canvas.tile_to_coords = (tile) =>
        [
          (@canvas.resolution[0] / 2) - (@tileSize() / 2) + @tileSize() * tile[0] + @camera[0],
          (@canvas.resolution[1] / 2) - (@tileSize() / 2) + @tileSize() * tile[1] + @camera[1]
        ]
    @canvas.coords_to_tile = (coords) =>
        [
          Math.floor( (coords[0] - (@canvas.resolution[0] / 2) + (@tileSize() / 2) - @camera[0]) / @tileSize() ),
          Math.floor( (coords[1] - (@canvas.resolution[1] / 2) + (@tileSize() / 2) - @camera[1]) / @tileSize() )
        ]

    @canvas.mousedown(@handleEvent)
    @canvas.mouseup(@handleEvent)


  handleEvent: (event) =>
    for register in @eventsRegister[event.type].reverse()
      break if register[event.type](event)

  startRender: ->
    @render = true

  tick: ->
    @$timeout( =>
      @draw() if @render
      @tick()
    , (1 / @framerate) * 1000)


  draw: ->
    console.log("tick")
    for object in @objects
      object.draw(@canvas)
    #request = @$http.get '/tweets', params: { ts: @timestamp }
    #request.then (result) =>
    #  @tweets = result.data
    #  @timestamp = Date.now()
]
