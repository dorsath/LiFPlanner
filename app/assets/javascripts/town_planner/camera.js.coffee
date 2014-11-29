app.service 'Camera', ['Town', class Camera
  constructor: (@Town) ->
    @moveCamera = false
    @lastReadPosition = false

  draw: (canvas) =>
    if @moveCamera
      canvas.camera[0] += canvas.mouseCoords[0] - @lastReadPosition[0]
      canvas.camera[1] += canvas.mouseCoords[1] - @lastReadPosition[1]
      
      @lastReadPosition = canvas.mouseCoords

  mousedown: (event, canvas) =>
    @moveCamera = true
    @lastReadPosition = canvas.mouseCoords
    return false

  mouseup: (event, canvas) =>
    @moveCamera = false
    for heightMap in @Town.heightMaps
      heightMap.redraw = true

  deactivate: ->

  activate: ->
]


Camera.$inject = ['Town']
