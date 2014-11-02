app = angular.module('Herbs', ['ngSanitize',"ngResource"]).run(['$compile', '$rootScope', '$document', ($compile, $rootScope, $document) ->
   return $document.on('page:load', ->
      body = angular.element('body')
      compiled = $compile(body.html())($rootScope)
      return body.html(compiled)
   )
])


app.factory "HerbList", ['$resource',($resource) ->
  $resource("/herbalism_lists/:id.json", {id: '@id'},{
    effects: { method: 'GET', url: "/herbalism_lists/effects.json", isArray: true}
  })]


app.factory "HerbItem", ['$resource',($resource) ->
  $resource("/herbalism_lists/:list_id/items/:id.json", {list_id: '@herbalism_list_id', id: '@id'},{
    update: { method:'PUT' },
    edit: { method: 'GET', url: "/herbalism_lists/:list_id/items/:id/edit?herb_id=:herb_id" }
  #  check_syntax: { method: 'GET', url: "/documents/:documentId/check_syntax.json", isArray: true},
  #  commit: { method: 'POST', url: "/documents/:documentId/commit.json"},
  #  pull: {method: 'POST', url: "/documents/:documentId/pull.json"},
  #  push: {method: 'POST', url: "/documents/:documentId/push.json"},
  #  pages: {method: 'GET', url: "/documents/:documentId/pages.json", isArray: true}
  #  master: {method: 'GET',  url: "/documents/:documentId/master.json"},
  })]

@HerbsCtrl = ($scope, $timeout, $http, HerbItem, HerbList) ->
  $scope.herbalism_list_id = $("#herbalism_list_id").val()

  class List
    constructor: (list_id) ->
      @list_id = list_id
      @effects = HerbList.effects( =>
        @filtered_effects = $.merge(["All"], @effects)
      )
      @list = HerbList.get({id: list_id})
      @currently_editing = false

    edit_effect: (item_id, n) =>
      return if @currently_editing 
      return if @editable == "false"
      @n = n
      td = $(".item_#{item_id}_#{n}")
      @currently_editing = HerbItem.get({list_id: @list_id, id: item_id})

      effect_id = $.inArray(td.html(), @effects)
      $http.get("/herbalism_lists/#{@list_id}/items/#{item_id}/edit?herb_id=#{effect_id}").success( (data) =>
        td.html(data)
        td.find("select").blur(@save_effect)
      )

    save_effect: =>
      td = $(".item_#{@currently_editing.id}_#{@n}")
      value = td.find(":selected")[0].index
      @currently_editing["#{@n}_effect_id"] = value
      @currently_editing.$update( =>
        td.html(@effects[value])
      )

      @currently_editing = false

    filter: =>
      console.log("filtering: #{@filtered_effect}")
      if @filtered_effect == "All"
        $("#herbs_table .herb_item").show()
      else
        $.each($("#herbs_table .herb_item"), (key, value) =>
          if $(value).find("td:contains(#{@filtered_effect})").length > 0
            $(value).show()
          else
            $(value).hide()

        )
      return ""
      
      
      

    
  $scope.list = new List($scope.herbalism_list_id)
  $scope.list.editable = $("#editable").val()



@HerbsCtrl.$inject = ['$scope', '$timeout', '$http', 'HerbItem', 'HerbList']
