app.service 'Cache', [class Cache
  constructor: ->

  cacheHeightMap: (heightMap, canvas, width, height)->
    cacheCanvas  = $("canvas#cache")
    cacheContext = cacheCanvas[0].getContext('2d')
    cacheCanvas[0].width = width
    cacheCanvas[0].height = height
    heightMap.draw(canvas, cacheContext)
    img = new Image()
    img.src = cacheCanvas[0].toDataURL("image/png")
    return img

]

