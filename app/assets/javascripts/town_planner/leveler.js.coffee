app.service 'Leveler', ['Selection', 'Town', 'HeightMap', class Leveler
  constructor: (@Selection, @Town, @HeightMap) ->
    console.log("Leveler:Constructor")
    @active = false
    @formVisible = false
    @height = 25

  save: =>
    area = @Selection.area
    heightMaps = []
    for tile in area
      heightMapCoordinates = @HeightMap.tile_to_height_map(tile)
      heightMap = @Town.findOrCreateHeightMap(heightMapCoordinates[0],heightMapCoordinates[1])
      heightMaps.push(heightMap) if $.inArray(heightMap, heightMaps) == -1
      areaIndex = (tile[0] - heightMapCoordinates[0]) + (tile[1] - heightMapCoordinates[1]) * 10
      heightMap.area[areaIndex] = @height

    for heightMap in heightMaps
      heightMap.$save()

    @formVisible = false
    @Selection.end()


  cancel: =>
    @active = false
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
    return @active

  mousedown: (event, canvas) =>
    if @active
      @Selection.start(event, canvas)
    return @active
]

