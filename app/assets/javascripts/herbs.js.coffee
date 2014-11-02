app = angular.module('Herbs', ['ngSanitize',"ngResource"]).run(['$compile', '$rootScope', '$document', ($compile, $rootScope, $document) ->
   return $document.on('page:load', ->
      body = angular.element('body')
      compiled = $compile(body.html())($rootScope)
      return body.html(compiled)
   )
])

