app.service 'Renderer', ['$timeout', class Renderer
  constructor: (@$timeout) ->
    console.log("Renderer:Constructor")
    @render = false
    @framerate = 60
    @objects = []
    @tileSize0 = 10
    @zoom = 4.2
    @eventsRegister = {
      mousedown: [],
      mouseup: []
    }
    
    window.onresize = =>
      @resolutionCorrection()

    @tick()

  tileSize: =>
    @zoom * @tileSize0


  resolutionCorrection: =>
    @canvas.resolution = [@canvas[0].offsetWidth, window.innerHeight - @canvas[0].offsetTop - 10]
    @canvas[0].width  = @canvas.resolution[0]
    @canvas[0].height = @canvas.resolution[1]

  setCanvas: (@canvas) =>
    @canvas.context = @canvas[0].getContext('2d')

    @resolutionCorrection()

    @canvas.camera = [0, 0]

    @canvas.tileSize = =>
      @tileSize()

    @canvas.zoom = =>
      @zoom

    @canvas.tile_to_coords = (tile) =>
        [
          (@canvas.resolution[0] / 2) - (@tileSize() / 2) + @tileSize() * tile[0] + @canvas.camera[0],
          (@canvas.resolution[1] / 2) - (@tileSize() / 2) + @tileSize() * tile[1] + @canvas.camera[1]
        ]
    @canvas.coords_to_tile = (coords) =>
        [
          Math.floor( (coords[0] - (@canvas.resolution[0] / 2) + (@tileSize() / 2) - @canvas.camera[0]) / @tileSize() ),
          Math.floor( (coords[1] - (@canvas.resolution[1] / 2) + (@tileSize() / 2) - @canvas.camera[1]) / @tileSize() )
        ]

    @canvas.mousedown(@handleEvent)
    @canvas.mouseup(@handleEvent)
    @canvas.mousemove(@handleMouseMoveEvent)

  handleEvent: (event) =>
    for register in @eventsRegister[event.type].reverse()
      break if register[event.type](event, @canvas)

  handleMouseMoveEvent: (event) =>
    @canvas.mouseCoords = [(event.clientX - @canvas[0].offsetLeft), (event.clientY - @canvas[0].offsetTop + $(document).scrollTop())]

  startRender: ->
    @render = true

  tick: ->
    @$timeout( =>
      @draw() if @render
      @tick()
    , (1 / @framerate) * 1000)


  draw: ->
    return unless @canvas

    @canvas.context.fillStyle = "white"
    @canvas.context.fillRect(0, 0, @canvas.resolution[0], @canvas.resolution[1])

    for object in @objects
      object.draw(@canvas)
    #request = @$http.get '/tweets', params: { ts: @timestamp }
    #request.then (result) =>
    #  @tweets = result.data
    #  @timestamp = Date.now()
]
