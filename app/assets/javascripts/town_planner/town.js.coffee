app.service 'Town', ['Building', 'HeightMap', 'Cache', class Town
  constructor: (@Building, @HeightMap, @Cache) ->
    @heightMapCaches = {}

  initialize: (@townId)=>
    @buildings = @Building.query(town_id: @townId)
    @heightMaps = @HeightMap.query(town_id: @townId)

  findOrCreateHeightMap: (x,y) =>
    if heightMap = @findHeightMap(x,y)
      return heightMap
    else
      newHeightMap = @HeightMap.create(town_id: @townId, x: x, y: y, area: @HeightMap.emptyArea())
      @heightMaps.push(newHeightMap)
      return newHeightMap
    

  findHeightMap: (x,y) =>
    return result = $.grep(@heightMaps, (heightMap) =>
      return heightMap.x == x && heightMap.y == y
    )[0]

  newBuilding: =>
    new @Building(town_id: @townId)

  findBuilding: (tile) =>
    result = false
    $.each(@buildings, (key, building) =>
      tile_found = $.grep(building.area, (buildingTile) =>
        return(buildingTile[0] == tile[0] && buildingTile[1] == tile[1])
      )
      if tile_found.length > 0
        result = building
        return
    )

    return result
    
  draw: (canvas) =>
    @drawBuildings(canvas)
    @drawHeightMaps(canvas)

  drawHeightMaps: (canvas) =>
    canvas.context.font = " #{3.7 * canvas.zoom()}px Arial"
    canvas.context.textBaseline = "middle"
    canvas.context.textAlign = 'center'
    for heightMap in @heightMaps
      topLeft = canvas.tile_to_coords([heightMap.x, heightMap.y])
      dimensions = [10 * canvas.tileSize(), 10 * canvas.tileSize()]
      if @heightMapCaches[heightMap.id] && heightMap.redraw != true
        canvas.context.drawImage(@heightMapCaches[heightMap.id], topLeft[0], topLeft[1])
      else
        heightMap.draw(canvas)
        @heightMapCaches[heightMap.id] = @Cache.cacheCanvas(canvas, topLeft[0], topLeft[1], dimensions[0], dimensions[1])
        heightMap.redraw = false


  drawBuildings: (canvas) =>
    for building in @buildings
      for tile in building.area
        coords = canvas.tile_to_coords(tile)
        canvas.context.fillStyle = "##{building.color}"
        canvas.context.fillRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())
        canvas.context.strokeStyle= "##{building.color}"
        canvas.context.strokeRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())


]


