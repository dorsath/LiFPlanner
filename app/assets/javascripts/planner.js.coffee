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
      @resolution = [@canvas[0].offsetWidth, window.innerHeight - @canvas[0].offsetTop - 10]
      @canvas.mousemove(@mousemove_event)
      @canvas[0].width  = @resolution[0]
      @canvas[0].height = @resolution[1]

      @mouse_down = false
      @mouse_move = false
      @camera = [0,0]

      @mode = "camera"
      @modes = ["camera", "draw"]

      @canvas.mousedown(@mouse_down_event)
      @canvas.mouseup(@mouse_up_event)

      @tile_size_0 = 10
      @zoom = 2.1
      @buildings = Building.query(town_id: @town_id)
      @buildingFactory = false


      @context = @canvas[0].getContext('2d')
      @context.lineWidth = 1
      @draw()


    center: =>
      @camera = [0,0]

    zoomIn: (amount) =>
      if amount + @zoom >= 1
        @zoom += amount

    tile_size: =>
      @zoom * @tile_size_0

    draw_tile: (x, y) =>
      coords = @tile_to_coords([x,y])
      @context.strokeRect(coords[0], coords[1], @tile_size(), @tile_size())

    draw: =>
      @context.fillStyle = "white"
      @context.fillRect(0, 0, @resolution[0], @resolution[1])

      top_left = @coords_to_tile([0,0])
      bottom_right = @coords_to_tile(@resolution)

      for x in [top_left[0]..bottom_right[0]]
        for y in [top_left[1]..bottom_right[1]]
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
      @mode = mode

    mouse_coords: (e) ->
      [(e.clientX - @canvas[0].offsetLeft), (e.clientY - @canvas[0].offsetTop + $(document).scrollTop())]

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

    getNumericStyleProperty: (style, prop) ->
      return parseInt(style.getPropertyValue(prop),10)

    element_position: (e) =>
        x = 0
        y = 0
        inner = true
        while (e = e.offsetParent)
          x += e.offsetLeft
          y += e.offsetTop
          style = getComputedStyle(e,null)
          borderTop = @getNumericStyleProperty(style,"border-top-width")
          borderLeft = @getNumericStyleProperty(style,"border-left-width")
          y += borderTop
          x += borderLeft
          if (inner)
            paddingTop = @getNumericStyleProperty(style,"padding-top")
            paddingLeft = @getNumericStyleProperty(style,"padding-left")
            y += paddingTop
            x += paddingLeft
          inner = false
        return [x,y]



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
        $scope.planner.buildings.push(@building)
        $scope.planner.buildingFactory = false
      )

    cancel: =>
      $scope.planner.buildingFactory = false



    

    
  $scope.town_id = $("#town_planner input#town_id").val()
  $scope.planner = new Planner($scope.town_id)

@PlannerCtrl.$inject = ['$scope', '$timeout', '$http', 'Building']

