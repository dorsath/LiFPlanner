app.service 'Syncing', ['$http','$timeout', 'Building', 'HeightMap', 'Town', class Syncing
  constructor: (@$http, @$timeout, @Building, @HeightMap, @Town) ->
    #@planner = $scope.planner
  
  getChanged: =>
    @$http.get("/towns/#{@Town.townId}/planner/changed.json").
      success( (data, status) =>
        if data.building.updated.length > 0
          @update(data.building.updated)
        if data.building.created.length > 0
          @add(data.building.created)

        if data.height_map.updated.length > 0
          @updateHeightMaps(data.height_map.updated)
        if data.height_map.created.length > 0
          @addHeightMaps(data.height_map.created)


        
      ).error( (data, status) ->
        console.log("changed http get error")
        console.log(data)
        console.log(status)
      )

  poll: =>
    @$timeout( =>
      @getChanged()
      @poll()
    , 3000)

  update: (ids) =>
    $.each(ids, (key, id) =>
      item = $.grep(@Town.buildings, (e) => 
        return e.id == id
      )[0]
      item.$get({town_id: @Town.townId})
    )

  add: (ids) =>
    $.each(ids, (key, id) =>
      items_found = $.grep(@Town.buildings, (e) => 
        return e.id == id
      )
      if items_found.length == 0
        item = @Building.get({town_id: @Town.townId, id: id}, =>
          @Town.buildings.push(item)
        )
    )

  updateHeightMaps: (ids) =>
    $.each(ids, (key, tile) =>
      item = $.grep(@Town.heightMaps, (e) => 
        return e.x == tile[0] && e.y == tile[1]
      )[0]
      if item
        item.$get({town_id: @Town.townId}, =>
          item.redraw = true
        )
    )

  addHeightMaps: (ids) =>
    $.each(ids, (key, tile) =>
      items_found = $.grep(@Town.heightMaps, (e) => 
        return e.x == tile[0] && e.y == tile[1]
      )
      if items_found.length == 0
        item = @HeightMap.get({town_id: @Town.townId, x: tile[0], y: tile[1]}, =>
          @Town.heightMaps.push(item)
        )
    )
]

Syncing.$inject = ['$timeout', 'Building', 'HeightMap', 'Town']
