app.service 'Town', ['Building', 'HeightMap', class Town
  constructor: (@Building, @HeightMap) ->
    console.log("Town:Constructor")


  initialize: (@townId)=>
    @buildings = @Building.query(town_id: @townId)
    @heightMaps = []
    @HeightMap.get(town_id: @townId, x: 0, y: 0, (data) =>
      @heightMaps.push(data)
    )
    console.log("Town:Initialize")

  draw: (canvas) =>
    @drawBuildings(canvas)
    @drawHeightMaps(canvas)


  coordinate_to_height_map: (coordinate) ->
    [
      Math.floor(coordinate[0] / 10) * 10,
      Math.floor(coordinate[1] / 10) * 10
    ]


  drawHeightMaps: (canvas) =>
    canvas.context.font = " #{4.7 * canvas.zoom()}px Arial"
    canvas.context.textBaseline = "middle"
    canvas.context.textAlign = 'center'
    for heightMap in @heightMaps
      for height, index in heightMap.area
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

        



    #top_left = canvas.coords_to_tile([0,0])
    #bottom_right = canvas.coords_to_tile(canvas.resolution)


  drawBuildings: (canvas) =>
    for building in @buildings
      for tile in building.area
        coords = canvas.tile_to_coords(tile)
        canvas.context.fillStyle = "##{building.color}"
        canvas.context.fillRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())


]


