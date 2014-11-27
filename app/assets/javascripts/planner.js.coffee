#= require town_planner/resources
#= require town_planner/renderer
#= require town_planner/grid
#= require town_planner/camera

@PlannerCtrl = app.controller 'PlannerCtrl', ($scope, $timeout, $http, Renderer, Building, Grid, Camera) ->
  startup = =>
    Renderer.setCanvas($("#town_planner").find("canvas#planner"))
    Renderer.eventsRegister.mousedown.push(Camera)
    Renderer.eventsRegister.mouseup.push(Camera)
    Renderer.objects.push(Camera)
    Renderer.objects.push(Grid)
    Renderer.startRender()
    #Renderer.draw()



  startup()



PlannerCtrl.$inject = ['$scope', '$timeout', '$http', 'Renderer', 'Building', 'Grid', 'Camera']

    #    constructor: ($scope, $timeout, $http, Building) ->
    #      @$timeout = $timeout
    #      @town_id = town_id
    #      @canvas = $("#town_planner").find("canvas#planner")
    #      @resizeCanvas()
    #
    #      @mouse_down = false
    #      @mouse_move = false
    #      @camera = [0,0]
    #
    #      @mode = "camera"
    #      @modes = ["camera", "build", "edit"]
    #
    #      @canvas.mousedown(@mouse_down_event)
    #      @canvas.mouseup(@mouse_up_event)
    #
    #      window.onresize = =>
    #        @resizeCanvas()
    #
    #      @tile_size_0 = 10
    #      @zoom = 2.1
    #      @buildings = Building.query(town_id: @town_id)
    #      @buildingFactory = false
    #      @editing = false
    #      @current_tile = false
    #
    #
    #      @context = @canvas[0].getContext('2d')
    #      @context.lineWidth = 1
    #      @draw()
    #
    #      @syncing = new Syncing()
    #      @syncing.poll()
    #
    #    resizeCanvas: =>
    #      @resolution = [@canvas[0].offsetWidth, window.innerHeight - @canvas[0].offsetTop - 10]
    #      @canvas.mousemove(@mousemove_event)
    #      @canvas[0].width  = @resolution[0]
    #      @canvas[0].height = @resolution[1]
    #
    #
    #    center: =>
    #      @camera = [0,0]
    #
    #    zoomIn: (amount) =>
    #      if amount + @zoom >= 1
    #        @zoom += amount
    #
    #    tile_size: =>
    #      @zoom * @tile_size_0
    #
    #    draw_tile: (x, y) =>
    #      coords = @tile_to_coords([x,y])
    #      @context.strokeRect(coords[0], coords[1], @tile_size(), @tile_size())
    #
    #    draw: =>
    #      @context.fillStyle = "white"
    #      @context.fillRect(0, 0, @resolution[0], @resolution[1])
    #
    #      top_left = @coords_to_tile([0,0])
    #      bottom_right = @coords_to_tile(@resolution)
    #
    #      @context.strokeStyle = "#eee"
    #      for x in [top_left[0]..bottom_right[0]]
    #        for y in [top_left[1]..bottom_right[1]]
    #          @draw_tile(x, y)
    #
    #      if @current_tile && (@mode == "build" || @mode == "edit")
    #        coords = @tile_to_coords(@current_tile)
    #        @context.fillStyle = "#DEDEDE"
    #        @context.fillRect(coords[0], coords[1], @tile_size(), @tile_size())
    #
    #    
    #      for building in @buildings
    #        for tile in building.area
    #          coords = @tile_to_coords(tile)
    #          @context.fillStyle = "green"
    #          @context.fillRect(coords[0], coords[1], @tile_size(), @tile_size())
    #
    #        text_coords = @tile_to_coords(building.center)
    #        text_coords[0] += @tile_size() / 2
    #        @context.textAlign = "center"
    #        @context.font = "17px Helvetica Neue"
    #        @context.textBaseline = "top"
    #        @context.fillStyle = "white"
    #        @context.fillText(building.title, text_coords[0], text_coords[1])
    #
    #      if @buildingFactory
    #        for tile in @buildingFactory.area
    #          coords = @tile_to_coords(tile)
    #          @context.fillStyle = "yellow"
    #          @context.fillRect(coords[0], coords[1], @tile_size(), @tile_size())
    #
    #
    #      @$timeout( =>
    #        @draw()
    #      , 20)
    #
    #    set_mode: (mode) =>
    #      @mode = mode
    #
    #    mouse_coords: (e) ->
    #      [(e.clientX - @canvas[0].offsetLeft), (e.clientY - @canvas[0].offsetTop + $(document).scrollTop())]
    #
    #    mouse_down_event: (e) =>
    #      @mouse_down = true
    #      
    #      if @mode == 'build'
    #        coords = @mouse_coords(e)
    #
    #        tile = @coords_to_tile(coords)
    #
    #        @buildingFactory = new BuildingFactory(tile)
    #        @mouse_action = @buildingFactory
    #
    #      if @mode == 'edit' && @tooltip
    #        @buildingFactory = new BuildingFactory([0,0])
    #        @buildingFactory.building = @tooltip
    #        @buildingFactory.area = @buildingFactory.building.area
    #        @buildingFactory.mode = "edit"
    #          
    #    tile_to_coords: (tile) =>
    #      [
    #        (@resolution[0] / 2) - (@tile_size() / 2) + @tile_size() * tile[0] + @camera[0],
    #        (@resolution[1] / 2) - (@tile_size() / 2) + @tile_size() * tile[1] + @camera[1]
    #      ]
    #
    #    coords_to_tile: (coords) =>
    #      [
    #        Math.floor( (coords[0] - (@resolution[0] / 2) + (@tile_size() / 2) - @camera[0]) / @tile_size() ),
    #        Math.floor( (coords[1] - (@resolution[1] / 2) + (@tile_size() / 2) - @camera[1]) / @tile_size() )
    #      ]
    #
    #
    #    mouse_up_event: (e) =>
    #      @mouse_down = false
    #      @mouse_move = false
    #
    #      if @mouse_action
    #        @mouse_action.mouse_up_event(@coords_to_tile(@mouse_coords(e)))
    #        @mouse_action = false
    #
    #
    #    mousemove_event: (e) =>
    #      mouse_coords = @mouse_coords(e)
    #      if @mouse_down
    #        if @mouse_move == false
    #          @mouse_move = mouse_coords
    #
    #        if @mode == 'camera'
    #          @camera[0] += mouse_coords[0] - @mouse_move[0]
    #          @camera[1] += mouse_coords[1] - @mouse_move[1]
    #
    #
    #        if @mouse_action
    #          @mouse_action.mousemove_event(@coords_to_tile(@mouse_coords(e)))
    #
    #      
    #        @mouse_move = mouse_coords
    #      else
    #        @current_tile = @coords_to_tile(mouse_coords)
    #
    #        found = false
    #        $.each(@buildings, (key, building) =>
    #          tile_found = $.grep(building.area, (tile) => 
    #            return(tile[0] == @current_tile[0] && tile[1] == @current_tile[1])
    #          )
    #          if tile_found.length > 0
    #            found = true
    #            @tooltip = building
    #
    #        )
    #        if found == false
    #          @tooltip = false
    #
    #
    #



#
#@PlannerCtrl = ($scope, $timeout, $http, Building) ->
#
#  class BuildingFactory
#    constructor: (tile) ->
#      @start_tile = tile
#      @current_tile = false
#      @area = []
#      @mode = "create"
#
#
#    mouse_up_event: (tile) =>
#      @new_form()
#
#    mousemove_event: (tile) =>
#      if @current_tile != tile
#        @area = []
#        for x in [@start_tile[0]..tile[0]]
#          for y in [@start_tile[1]..tile[1]]
#            @area.push([x,y])
#
#      @current_tile = tile
#
#
#    new_form: =>
#      @building = Building.new(town_id: $scope.town_id, =>
#        @building.area = @area
#      )
#
#    save: =>
#      if @mode == "create"
#        @building.$save(town_id: $scope.town_id, =>
#          $scope.planner.buildings.push(@building)
#        )
#      else
#        @building.$update(town_id: $scope.town_id)
#      $scope.planner.buildingFactory = false
#
#    cancel: =>
#      $scope.planner.buildingFactory = false
#
#    delete: =>
#      @building.$delete(town_id: $scope.town_id, =>
#        index = $scope.planner.buildings.indexOf(@building)
#        $scope.planner.buildings.splice(index, 1)
#        $scope.planner.buildingFactory = false
#      )
#
#
#  class Syncing
#    constructor: ->
#      @planner = $scope.planner
#
#    poll: =>
#      $timeout( ->
#        @planner = $scope.planner
#        changed = Building.changed(town_id: @planner.town_id, =>
#          if changed.updated.length > 0
#            @planner.syncing.update(changed.updated)
#          if changed.created.length > 0
#            @planner.syncing.add(changed.created)
#        )
#        @planner.syncing.poll()
#      , 3000)
#
#    update: (ids) =>
#      @planner = $scope.planner
#      $.each(ids, (key, id) =>
#        item = $.grep(@planner.buildings, (e) => 
#          return e.id == id
#        )[0]
#        console.log(item)
#
#        #item.$get({town_id: @town_id})
#      )
#
#    add: (ids) =>
#      @planner = $scope.planner
#      $.each(ids, (key, id) =>
#        items_found = $.grep(@planner.buildings, (e) => 
#          return e.id == id
#        )
#        if items_found.length == 0
#          item = Building.get({town_id: @planner.town_id, id: id}, =>
#            @planner.buildings.push(item)
#          )
#      )
#
#
#
#
#    
#
#    
#  $scope.town_id = $("#town_planner input#town_id").val()
#  $scope.planner = new TownPlanner.Planner($scope.town_id)
#
@PlannerCtrl.$inject = ['$scope', '$timeout', '$http', 'Building']
