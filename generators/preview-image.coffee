class PreviewImage
  constructor: (@src, @image, @panel) ->
    @mime = "image/#{image.getExtension()}"

  generate: ->
    return new Promise (resolve, reject) =>
      resolve @create()

  base64Src: (src) ->
    "data:#{@mime};base64,#{@src}"

  create: (src, image) ->
    src = @base64Src()
    @img         = new KDCustomHTMLView
      tagName    : "img"
      cssClass   : "preview-img"
      bind       : "load error"
      attributes : { src }

    @img.once "load",  => @panel.loader.hide()
    @img.once "error", => @panel.loader.hide()

    return @img

