app.service 'BuildingFactory', ['Selection', 'Town', 'Building', class BuildingFactory
  constructor: (@Selection, @Town, @Building) ->
    @formVisible = false
    @active = false

  save: =>
    @building.$save( =>
      @Town.buildings.push(@building)
    )
    @formVisible = false
    @Selection.end()

  cancel: =>
    @Selection.end()
    @formVisible = false

  delete: =>
    @building.$delete(=>
      index = @Town.buildings.indexOf(@building)
      @Town.buildings.splice(index, 1)
      @formVisible = false
    )

  mouseup: =>
    if @active
      @Selection.stopSelecting()
      @formVisible = true
      @building.area = @Selection.area unless @mode == "edit"
    return @active

  mousedown: (event, canvas) =>
    if @active
      @building = @Town.findBuilding(canvas.coords_to_tile(canvas.mouseCoords))
      if @building
        @formVisible = true
        @mode = "edit"
      else
        @building = @Town.newBuilding()
        @Selection.start(event, canvas)
    return @active

  activate: =>
    @active = true

  deactivate: =>
    @formVisible = false
    @Selection.end()
    @active = false
]

