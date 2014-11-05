app = angular.module('Herbs')

app.factory "TodoList", ['$resource',($resource) ->
  $resource("/towns/:town_id/todo_list.json", {id: '@id'},{
    changed: { method: 'GET', url: "/towns/:id/todo_list/changed.json"}
  })]

app.factory "TodoItem", ['$resource',($resource) ->
  $resource("/towns/:town_id/todo_list/items/:id.json", {town_id: '@town_id', id: '@id'},{
    items: { method: 'GET', url: "/towns/:town_id/todo_list/items.json", isArray: true},
    create: { method: 'POST', url: "/towns/:town_id/todo_list/items.json"},
    save: { method: 'PUT', url: "/towns/:town_id/todo_list/items/:id.json"}
  })]

@TodoList = ($scope, $timeout, $http, TodoList, TodoItem) ->
  $scope.town_id = $("#town_id").val()

  class List
    constructor: (town_id) ->
      @town_id = town_id
      @items = TodoItem.items(town_id: town_id)
      @status = ["created", "started", "completed"]
      @poll()
      @editing = false


    new_todo: =>
      new_item = new TodoItem({town_id: @town_id, title: @new_todo_title})
      new_item.$create(=>
        @items.push(new_item)
        @new_todo_title = ""
      )


    poll: =>
      $timeout( ->
        @list = $scope.list
        changed = TodoList.changed(id: @list.town_id, =>
          if changed.updated.length > 0
            @list.update(changed.updated)
          if changed.created.length > 0
            @list.add(changed.created)
        )
        $scope.list.poll()
      , 3000)

    update: (ids) =>
      $.each(ids, (key, id) =>
        item = $.grep(@items, (e) => 
          return e.id == id
        )[0]

        item.$get({town_id: @town_id})
        $("#todo_list_table .item_#{item.id}").show()
      )

    add: (ids) =>
      $.each(ids, (key, id) =>
        items_found = $.grep(@items, (e) => 
          return e.id == id
        )
        if items_found.length == 0
          item = TodoItem.get({town_id: @town_id, id: id}, =>
            @items.push(item)
          )
      )

    edit: (item, field) =>
      return if @editing

      @editing = [item, field]
      console.log(item)
      console.log(field)
      td = $("#todo_list_table .item_#{item.id} .#{field}")
      td.html('<input type="text" value="'+td.html()+'"/>')
      $(td).find("input").blur(@save_change)
      
      return ""

    save_change: =>
      item = @editing[0]
      field = @editing[1]
      td = $("#todo_list_table .item_#{item.id} .#{field}")
      value = td.find("input").val()
      td.html(value)
      item[field] = value
      item.$save(town_id: @town_id)

    row_class: (item) ->
      "item_#{item.id}"



    complete: (item) =>
      item.$save({town_id: @town_id})

    toggle_completed: =>
      if @hide_completed
        $.each($("#todo_list_table tr"), (key, value) =>
          if $(value).find('input[type="checkbox"]').prop('checked')
            $(value).hide()
          else
            $(value).show()

        )
      else
        $("#todo_list_table tr").show()
      return ""



  $scope.list = new List($scope.town_id)

@TodoList.$inject = ['$scope', '$timeout', '$http', 'TodoList', 'TodoItem']

