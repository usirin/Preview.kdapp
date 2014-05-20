class PreviewImage extends BaseFile
  constructor: (@src, @image, @panel) ->
    super @src, @image, @panel

  mime: -> "image/#{@image.getExtension()}"

  webPrefix: -> ".kd.link-image"

  create: (src, image) ->
    src ||= @base64Src()
    @img         = new KDCustomHTMLView
      tagName    : "img"
      cssClass   : "preview-img"
      bind       : "load error"
      attributes : { src }

    @img.once "load",  => @panel.loader.hide()
    @img.once "error", => @panel.loader.hide()

    return @img

