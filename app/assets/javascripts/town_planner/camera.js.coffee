app.service 'Camera', [class Camera
  constructor: ->
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

  deactivate: ->

  activate: ->
]


