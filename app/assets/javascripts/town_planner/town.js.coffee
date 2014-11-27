app.service 'Town', ['Building', class Town
  constructor: (@Building) ->
    console.log("Town:Constructor")

  initialize: (@townId)=>
    @buildings = @Building.query(town_id: @townId)
    console.log("Town:Constructor")

  draw: (canvas) =>
    for building in @buildings
      for tile in building.area
        coords = canvas.tile_to_coords(tile)
        canvas.context.fillStyle = "##{building.color}"
        canvas.context.fillRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())


]


