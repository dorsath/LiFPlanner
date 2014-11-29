app.service 'Leveler', ['Selection', 'Town', 'HeightMap', class Leveler
  constructor: (@Selection, @Town, @HeightMap) ->
    @active = false
    @formVisible = false
    @height = ""

  save: =>
    area = @Selection.area
    heightMaps = []
    for tile in area
      heightMapCoordinates = @HeightMap.tile_to_height_map(tile)
      heightMap = @Town.findOrCreateHeightMap(heightMapCoordinates[0],heightMapCoordinates[1])
      heightMaps.push(heightMap) if $.inArray(heightMap, heightMaps) == -1
      areaIndex = (tile[0] - heightMapCoordinates[0]) + (tile[1] - heightMapCoordinates[1]) * 10
      heightMap.area[areaIndex] =  parseFloat(@height)

    for heightMap in heightMaps
      heightMap.$save( =>
        heightMap.redraw = true
      )

    @formVisible = false
    @Selection.end()


  cancel: =>
    @formVisible = false
    @Selection.end()

  activate: =>
    @active = true

  deactivate: =>
    @active = false

  mouseup: =>
    if @active
      @Selection.stopSelecting()
      @formVisible = true
      setTimeout(=>
        $("#levelerHeight").focus()
      , 100)
    return @active

  mousedown: (event, canvas) =>
    if @active
      @Selection.start(event, canvas)
    return @active
]

