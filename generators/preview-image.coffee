class PreviewImage extends BaseFile

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

