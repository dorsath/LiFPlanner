app = angular.module('Herbs')

app.factory "TodoList", ['$resource',($resource) ->
  $resource("/towns/:town_id/todo_list.json", {id: '@id'},{
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


    new_todo: =>
      new_item = new TodoItem({town_id: @town_id, title: @new_todo_title})
      new_item.$create(=>
        @items.push(new_item)
        @new_todo_title = ""
      )
      console.log(new_item)

    #start: (item_id) =>
      #  item = TodoItem.get(town_id: @town_id, id: item_id, =>
      #    item.status_id = 1
      #    item.$save({town_id: @town_id})
      #  )

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

