app = angular.module('Herbs')


@PlannerCtrl = ($scope, $timeout, $http) ->

  class Planner
    constructor: (town_id) ->
      @town_id = town_id
      @canvas = $("#town_planner").find("canvas#planner")
      @resolution = [@canvas.prop("width"), @canvas.prop("height")]

      @tile_size_0 = 10
      @zoom = 1

      console.log(@resolution)
      @context = @canvas[0].getContext('2d')
      @draw(0,0)
      @draw(1,0)
      @draw(2,1)

    tile_size: =>
      @zoom * @tile_size_0

    draw: (x, y) =>
      x_0 = (@resolution[0] / 2) - (@tile_size() / 2) + @tile_size() * x
      y_0 = (@resolution[1] / 2) - (@tile_size() / 2) + @tile_size() * y
      @context.strokeRect(x_0, y_0, @tile_size(), @tile_size())

    
  $scope.town_id = $("#town_planner input#town_id").val()
  $scope.planner = new Planner($scope.town_id)

@PlannerCtrl.$inject = ['$scope', '$timeout', '$http']
