app.factory "Building", ['$resource',($resource) ->
  $resource("/towns/:town_id/planner/buildings/:id.json", {town_id: '@town_id', id: '@id'},{
    new: { method: 'GET', url: "/towns/:town_id/planner/buildings/new.json"},
    changed: { method: 'GET', url: "/towns/:town_id/planner/changed.json"},
    save: { method: 'POST', url: "/towns/:town_id/planner/buildings.json"},
    update: { method: 'PUT', url: "/towns/:town_id/planner/buildings/:id.json"}
  })]
