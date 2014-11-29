app.service 'BuildingFactory', ['Selection', 'Town', 'Building', class BuildingFactory
  constructor: (@Selection, @Town, @Building) ->
    @formVisible = false
    @active = false
    @building = false
    @colors = [
      "fce94f", "edd400", "c4a000", "fcaf3e", "f57900", "ce5c00", "e9b96e",
      "c17d11", "8f5902", "8ae234", "73d216", "439a06", "729fcf", "3465a4",
      "204a87", "ad7fa8", "75507b", "5c3566", "ef2929", "cc0000", "a40000",
      "555753"
    ]

  getColorStatus: (color) =>
    return "active" if @building && @building.color == color
    return ""

  save: =>
    if @mode == "edit"
      @building.$update()
    else
      @building.$save( =>
        @Town.buildings.push(@building)
      )

    @formVisible = false
    @Selection.end()

  cancel: =>
    @Selection.end()
    @formVisible = false
    @building.color = @colorBackup if @mode == "edit"

  delete: =>
    @building.$delete(=>
      index = @Town.buildings.indexOf(@building)
      @Town.buildings.splice(index, 1)
      @formVisible = false
      @Town.HeightMap.redraw(@Town.heightMaps)
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
        @mode = "create"
        @building = @Town.newBuilding()
        @Selection.start(event, canvas)
      @colorBackup = @building.color
    return @active

  activate: =>
    @active = true

  deactivate: =>
    @formVisible = false
    @Selection.end()
    @active = false
]

