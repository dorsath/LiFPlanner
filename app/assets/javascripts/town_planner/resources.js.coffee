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
    create: { method: 'POST'}
  })

  HeightMap.tile_to_height_map = (coordinate) ->
    [
      Math.floor(coordinate[0] / 10) * 10,
      Math.floor(coordinate[1] / 10) * 10
    ]

  HeightMap.emptyArea = ->
    return (0 for [1..100])

    

  return HeightMap
]

