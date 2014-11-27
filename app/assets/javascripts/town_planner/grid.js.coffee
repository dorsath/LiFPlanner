app.service 'Grid', [class Grid
  constructor: ->
    console.log("Grid:Constructor")

  draw: (canvas) ->
    top_left = canvas.coords_to_tile([0,0])
    bottom_right = canvas.coords_to_tile(canvas.resolution)

    canvas.context.strokeStyle = "#eee"
    for x in [top_left[0]..bottom_right[0]]
      for y in [top_left[1]..bottom_right[1]]
        coords = canvas.tile_to_coords([x,y])
        canvas.context.strokeRect(coords[0], coords[1], canvas.tileSize(), canvas.tileSize())

]

