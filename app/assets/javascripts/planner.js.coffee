#= require town_planner/resources
#= require town_planner/renderer
#= require town_planner/grid
#= require town_planner/camera
#= require town_planner/town
#= require town_planner/selection
#= require town_planner/leveler
#= require town_planner/building_factory
#= require town_planner/syncing
#= require town_planner/cache

@PlannerCtrl = app.controller 'PlannerCtrl', ['$scope', '$timeout', '$http', 'Renderer', 'Building', 'HeightMap', 'Grid', 'Camera', 'Town', 'Leveler', 'Selection', 'BuildingFactory', 'Syncing', ($scope, $timeout, $http, Renderer, Building, HeightMap, Grid, Camera, Town, Leveler, Selection, BuildingFactory, Syncing) ->
  startup = =>
    @townId = $("#town_id").val()
    $scope.modes = [
      ["Camera", Camera],
      ["Flatten",Leveler],
      ["Build",BuildingFactory]
    ]
    $scope.activeMode = ["Camera", Camera]
    $scope.leveler = Leveler
    $scope.buildingFactory = BuildingFactory

    $scope.zoomIn = (zoom) =>
      Renderer.zoom += zoom
      HeightMap.redraw(Town.heightMaps)

    $scope.center = =>
      Renderer.canvas.camera = [0, 0]
      HeightMap.redraw(Town.heightMaps)

    $scope.setMode = (name, mode) =>
      $scope.activeMode[1].deactivate() if $scope.activeMode
      $scope.activeMode = [name, mode]
      mode.activate()

    Renderer.setCanvas($("#town_planner").find("canvas#planner"))
    Renderer.addToEventsRegister(Camera)
    Renderer.addToEventsRegister(Leveler)
    Renderer.addToEventsRegister(BuildingFactory)
    Renderer.objects.push(Camera)

    Town.initialize(@townId)

    Renderer.objects.push(Grid)
    Renderer.objects.push(Town)
    Renderer.objects.push(Selection)

    Renderer.startRender()
    #$timeout( ->
    #  Renderer.draw()
    #, 500)

    #Syncing.poll()



  startup()

]


PlannerCtrl.$inject = ['$scope', '$timeout', '$http', 'Renderer', 'Building', 'HeightMap', 'Grid', 'Camera', 'Town', 'Leveler', 'Selection', 'BuildingFactory', 'Syncing']
