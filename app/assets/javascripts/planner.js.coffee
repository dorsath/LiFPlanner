app = angular.module('Herbs')


@PlannerCtrl = ($scope, $timeout, $http) ->

  class Planner
    constructor: (town_id) ->
      @town_id = town_id
      @canvas = $("#town_planner").find("canvas#planner")
      @resolution = [@canvas.prop("width"), @canvas.prop("height")]
      @canvas.mousemove(@mousemove_event)

      @mouse_down = false
      @mouse_move = false
      @mouse_dt = [0,0]

      @mode = "camera"

      @canvas.mousedown(@mouse_down_event)
      @canvas.mouseup(@mouse_up_event)

      @tile_size_0 = 10
      @zoom = 2

      console.log(@resolution)
      @context = @canvas[0].getContext('2d')
      @context.lineWidth = 1
      @draw()

    tile_size: =>
      @zoom * @tile_size_0

    draw_tile: (x, y) =>
      x_0 = (@resolution[0] / 2) - (@tile_size() / 2) + @tile_size() * x + @mouse_dt[0]
      y_0 = (@resolution[1] / 2) - (@tile_size() / 2) + @tile_size() * y + @mouse_dt[1]
      @context.strokeRect(x_0, y_0, @tile_size(), @tile_size())

    draw_menu: =>
      @context.fillStyle = "yellow"
      @context.fillRect(0, 0, 20, 20)
      @context.strokeRect(0, 0, 20, 20)

    draw: =>
      @context.fillStyle = "white"
      @context.fillRect(0, 0, @resolution[0], @resolution[1])

      for x in [-10..10]
        for y in [-10..10]
          @draw_tile(x, y)

      @draw_menu()

      $timeout( =>
        @draw()
      , 20)

    mouse_down_event: =>
      @mouse_down = true

    mouse_up_event: =>
      @mouse_down = false
      @mouse_move = false

    mousemove_event: (e) =>
      if @mouse_down
        mouse_coords = [e.clientX - @canvas[0].offsetLeft, e.clientY - @canvas[0].offsetTop]
        if @mouse_move == false
          @mouse_move = mouse_coords

        @mouse_dt[0] = @mouse_dt[0] + mouse_coords[0] - @mouse_move[0]
        @mouse_dt[1] = @mouse_dt[1] + mouse_coords[1] - @mouse_move[1]

        @mouse_move = mouse_coords





    

    
  $scope.town_id = $("#town_planner input#town_id").val()
  $scope.planner = new Planner($scope.town_id)

@PlannerCtrl.$inject = ['$scope', '$timeout', '$http']
