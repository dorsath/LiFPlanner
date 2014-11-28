app.service 'Selection', [class Selection
  constructor: ->

  start: (@event, @canvas) =>
    @active = true
    @selecting = true
    @area = []
    @startTile = @canvas.coords_to_tile(@canvas.mouseCoords)

  draw: (canvas) =>
    return unless @active
    if @currentTile == canvas.coords_to_tile(canvas.mouseCoords) || @selecting == false
      area = @area
    else
      area = @getArea(canvas)
 
    canvas.context.strokeStyle = "#2e3456"
    for tile in area
      coords = canvas.tile_to_coords(tile)
      canvas.context.strokeRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())

  getArea: (canvas) =>
    @currentTile = canvas.coords_to_tile(canvas.mouseCoords)
    @area = []
    for x in [@startTile[0]..@currentTile[0]]
      for y in [@startTile[1]..@currentTile[1]]
        @area.push([x,y])
    return @area

  end: =>
    @active = false
    @selecting = false

  stopSelecting: =>
    @selecting = false
]
