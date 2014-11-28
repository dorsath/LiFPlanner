app.service 'Syncing', ['$timeout', 'Building', 'Town', class Syncing
  constructor: (@$timeout, @Building, @Town) ->
    #@planner = $scope.planner

  poll: =>
    console.log("Syncing:Poll")
    @$timeout( =>
      changed = @Building.changed(town_id: @Town.townId, =>
        if changed.updated.length > 0
          @update(changed.updated)
        if changed.created.length > 0
          @add(changed.created)
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
]
