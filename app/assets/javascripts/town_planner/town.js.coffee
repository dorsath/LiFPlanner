app.service 'Town', ['Building', 'HeightMap', class Town
  constructor: (@Building, @HeightMap) ->
    console.log("Town:Constructor")


  initialize: (@townId)=>
    @buildings = @Building.query(town_id: @townId)
    @heightMaps = @HeightMap.query(town_id: @townId)
    console.log("Town:Initialize")

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
    canvas.context.font = " #{4.7 * canvas.zoom()}px Arial"
    canvas.context.textBaseline = "middle"
    canvas.context.textAlign = 'center'
    for heightMap in @heightMaps
      for height, index in heightMap.area
        continue if height == 0
        tile = [
          heightMap.x + index % 10,
          heightMap.y + Math.floor(index / 10)
        ]
        coords = canvas.tile_to_coords(tile)
        coords[0] += (canvas.tileSize() / 2)
        coords[1] += (canvas.tileSize() / 2)
        rgb = canvas.context.getImageData(coords[0], coords[1], 1, 1).data
        hex = '#' + ((rgb[0] << 16) | (rgb[1] << 8) | rgb[2]).toString(16)
        if hex == "#0" or hex == "#ffffff"
          canvas.context.fillStyle = "#d3d7cf"
        else
          canvas.context.fillStyle = "white"
        canvas.context.fillText(height,coords[0], coords[1])


  drawBuildings: (canvas) =>
    for building in @buildings
      for tile in building.area
        coords = canvas.tile_to_coords(tile)
        canvas.context.fillStyle = "##{building.color}"
        canvas.context.fillRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())
        canvas.context.strokeStyle= "#73d216"
        canvas.context.strokeRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())


]


