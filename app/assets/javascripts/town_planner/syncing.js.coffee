app.service 'Syncing', ['$timeout', 'Building', 'HeightMap', 'Town', class Syncing
  constructor: (@$timeout, @Building, @HeightMap, @Town) ->
    #@planner = $scope.planner

  poll: =>
    @$timeout( =>
      changed = @Building.changed(town_id: @Town.townId, =>
        if changed.updated.length > 0
          @update(changed.updated)
        if changed.created.length > 0
          @add(changed.created)
      )

      changedHeightMaps = @HeightMap.changed(town_id: @Town.townId, =>
        if changedHeightMaps.updated.length > 0
          @updateHeightMaps(changedHeightMaps.updated)
        if changedHeightMaps.created.length > 0
          @addHeightMaps(changedHeightMaps.created)
      )
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
      item.$get({town_id: @Town.townId}) if item
    )

  addHeightMaps: (ids) =>
    $.each(ids, (key, tile) =>
      items_found = $.grep(@Town.heightMaps, (e) => 
        return e.x == tile[0] && e.y == tile[1]
      )
      if items_found.length == 0
        item = @HeightMap.get({town_id: @Town.townId, x: tile[0], y: tile[1]}, =>
          console.log(item)
          @Town.heightMaps.push(item)
        )
    )
]
