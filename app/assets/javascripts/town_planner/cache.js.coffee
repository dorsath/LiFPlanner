app.service 'Cache', [class Cache
  constructor: ->

  cacheCanvas: (canvas, x, y, width, height)->
    imageData = canvas.context.getImageData(x, y, width, height)
    cacheCanvas  = $("canvas#cache")
    cacheContext = cacheCanvas[0].getContext('2d')
    cacheCanvas[0].width = width
    cacheCanvas[0].height = height
    cacheContext.putImageData(imageData, 0, 0)
    img = new Image()
    img.src = cacheCanvas[0].toDataURL("image/png")
    return img

]

