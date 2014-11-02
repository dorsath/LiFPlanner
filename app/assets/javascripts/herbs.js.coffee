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
