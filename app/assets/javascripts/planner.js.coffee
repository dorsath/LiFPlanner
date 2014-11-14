app = angular.module('Herbs')

app.factory "Building", ['$resource',($resource) ->
  $resource("/towns/:town_id/planner/buildings/:id.json", {town_id: '@town_id', id: '@id'},{
    new: { method: 'GET', url: "/towns/:town_id/planner/buildings/new.json"}
  })]


@PlannerCtrl = ($scope, $timeout, $http, Building) ->

  class Planner
    constructor: (town_id) ->
      @town_id = town_id
      @canvas = $("#town_planner").find("canvas#planner")
      @resolution = [@canvas.prop("width"), @canvas.prop("height")]
      @canvas.mousemove(@mousemove_event)

      @mouse_down = false
      @mouse_move = false
      @camera = [0,0]

      @mode = "camera"

      @canvas.mousedown(@mouse_down_event)
      @canvas.mouseup(@mouse_up_event)

      @tile_size_0 = 10
      @zoom = 2
      @buildings = Building.query(town_id: @town_id)
      @buildingFactory = false

      console.log(@resolution)

      @context = @canvas[0].getContext('2d')
      @context.lineWidth = 1
      @draw()

    tile_size: =>
      @zoom * @tile_size_0

    draw_tile: (x, y) =>
      coords = @tile_to_coords([x,y])
      @context.strokeRect(coords[0], coords[1], @tile_size(), @tile_size())

    draw: =>
      @context.fillStyle = "white"
      @context.fillRect(0, 0, @resolution[0], @resolution[1])

      for x in [-10..10]
        for y in [-10..10]
          @draw_tile(x, y)
    
      if @buildingFactory
        for tile in @buildingFactory.area
          coords = @tile_to_coords(tile)
          @context.fillStyle = "yellow"
          @context.fillRect(coords[0], coords[1], @tile_size(), @tile_size())

      for building in @buildings
        for tile in building.area
          coords = @tile_to_coords(tile)
          @context.fillStyle = "green"
          @context.fillRect(coords[0], coords[1], @tile_size(), @tile_size())

      $timeout( =>
        @draw()
      , 20)

    set_mode: (mode) =>
      console.log(mode)
      @mode = mode

    mouse_coords: (e) ->
      mouse_coords = [(e.clientX - @canvas[0].offsetLeft) / window.devicePixelRatio, (e.clientY - @canvas[0].offsetTop) / window.devicePixelRatio]

    mouse_down_event: (e) =>
      @mouse_down = true
      
      if @mode == 'draw'
        coords = @mouse_coords(e)

        tile = @coords_to_tile(coords)

        @buildingFactory = new BuildingFactory(tile)
        @mouse_action = @buildingFactory
          
    tile_to_coords: (tile) =>
      [
        (@resolution[0] / 2) - (@tile_size() / 2) + @tile_size() * tile[0] + @camera[0],
        (@resolution[1] / 2) - (@tile_size() / 2) + @tile_size() * tile[1] + @camera[1]
      ]

    coords_to_tile: (coords) =>
      [
        Math.floor( (coords[0] - (@resolution[0] / 2) + (@tile_size() / 2) - @camera[0]) / @tile_size() ),
        Math.floor( (coords[1] - (@resolution[1] / 2) + (@tile_size() / 2) - @camera[1]) / @tile_size() )
      ]


    mouse_up_event: (e) =>
      @mouse_down = false
      @mouse_move = false

      if @mouse_action
        @mouse_action.mouse_up_event(@coords_to_tile(@mouse_coords(e)))
        @mouse_action = false


    mousemove_event: (e) =>
      if @mouse_down
        mouse_coords = @mouse_coords(e)
        if @mouse_move == false
          @mouse_move = mouse_coords

        if @mode == 'camera'
          @camera[0] += mouse_coords[0] - @mouse_move[0]
          @camera[1] += mouse_coords[1] - @mouse_move[1]


        if @mouse_action
          @mouse_action.mousemove_event(@coords_to_tile(@mouse_coords(e)))

        @mouse_move = mouse_coords


  class BuildingFactory
    constructor: (tile) ->
      @start_tile = tile
      @current_tile = false
      @area = []

    mouse_up_event: (tile) =>
      @new_form()

    mousemove_event: (tile) =>
      if @current_tile != tile
        @area = []
        for x in [@start_tile[0]..tile[0]]
          for y in [@start_tile[1]..tile[1]]
            @area.push([x,y])

      @current_tile = tile

    new_form: =>
      @building = Building.new(town_id: $scope.town_id, =>
        @building.area = @area
      )

    save: =>
      @building.$save(town_id: $scope.town_id, =>
        console.log("Building saved")
        $scope.planner.buildings.push(@building)
        $scope.planner.buildingFactory = false
      )

    cancel: =>
      $scope.planner.buildingFactory = false



    

    
  $scope.town_id = $("#town_planner input#town_id").val()
  $scope.planner = new Planner($scope.town_id)

@PlannerCtrl.$inject = ['$scope', '$timeout', '$http', 'Building']
