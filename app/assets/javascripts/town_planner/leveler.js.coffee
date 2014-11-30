app.service 'Leveler', ['Selection', 'Town', 'HeightMap', class Leveler
  constructor: (@Selection, @Town, @HeightMap) ->
    @active = false
    @formVisible = false
    @height = ""

  save: =>
    area = @Selection.area
    heightMaps = {}
    for tile in area
      heightMapCoordinates = @HeightMap.tile_to_height_map(tile)
      x = heightMapCoordinates[0]
      y = heightMapCoordinates[1]
      key = "#{x}:#{y}"
      heightMaps[key] = [] unless heightMaps[key]
      areaIndex = (tile[0] - heightMapCoordinates[0]) + (tile[1] - heightMapCoordinates[1]) * 10
      heightMaps[key].push(areaIndex)

      #heightMap = @Town.findHeightMap(x,y)
      #if heightMap
      #  newHeightMap = @HeightMap.create(town_id: @townId, x: x, y: y, area: @HeightMap.emptyArea())
      #  @heightMaps.push(newHeightMap)
      #  return newHeightMap
      #heightMaps.push(heightMap) if $.inArray(heightMap, heightMaps) == -1 #-1 means not in array
      #heightMap.area[areaIndex] =  parseFloat(@height)

    for key, map of heightMaps
      k = key.split(":")
      x = parseInt(k[0])
      y = parseInt(k[1])
      heightMap = @Town.findHeightMap(x,y)
      if heightMap
        for index in map
          heightMap.area[index] = @height

        heightMap.$save()
        heightMap.redraw = true
      else
        area = @HeightMap.newArea(parseFloat(@height), map)
        @HeightMap.create({town_id: @Town.townId, x: x, y: y, area: area}, (record) =>
          record.redraw = true
          @Town.heightMaps.push(record)
        )

      #heightMap.$save( =>
      #  heightMap.redraw = true
      #)

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

Leveler.$inject = ['Selection', 'Town', 'HeightMap']
