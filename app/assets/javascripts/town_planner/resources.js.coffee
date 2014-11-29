app.factory "Building", ['$resource',($resource) ->
  $resource("/towns/:town_id/planner/buildings/:id.json", {town_id: '@town_id', id: '@id'},{
    new: { method: 'GET', url: "/towns/:town_id/planner/buildings/new.json"},
    changed: { method: 'GET', url: "/towns/:town_id/planner/changed.json"},
    save: { method: 'POST', url: "/towns/:town_id/planner/buildings.json"},
    update: { method: 'PUT', url: "/towns/:town_id/planner/buildings/:id.json"}
  })]

app.factory "HeightMap", ['$resource', ($resource) -> 
  HeightMap = $resource("/towns/:town_id/planner/height_maps/:x/:y.json", {town_id: '@town_id', x: '@x', y: '@y'},{
    save: { method: 'PATCH'},
    create: { method: 'POST'},
    changed: { method: 'GET', url: "/towns/:town_id/planner/height_maps/changed.json"}
  })

  HeightMap.tile_to_height_map = (coordinate) ->
    [
      Math.floor(coordinate[0] / 10) * 10,
      Math.floor(coordinate[1] / 10) * 10
    ]

  HeightMap.emptyArea = ->
    return (0 for [1..100])

  HeightMap.prototype.draw = (canvas) ->
    for height, index in @area
      continue if height == 0
      tile = [
        @x + index % 10,
        @y + Math.floor(index / 10)
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

  HeightMap.redraw = (heightMaps) ->
    for heightMap in heightMaps
      heightMap.redraw = true


  return HeightMap
]

