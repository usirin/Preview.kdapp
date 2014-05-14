class PreviewVideo
  constructor: (@src, @music, @panel) ->
    @mime = "video/#{@music.getExtension()}"
    return @create()

  base64Src: (src) ->
    "data:#{@mime};base64,#{@src}"

  create: (src, music) ->
    src = @base64Src()
    @music       = new KDCustomHTMLView
      tagName    : "video"
      cssClass   : "preview-video"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true

    @music.once "loadeddata",  => @panel.loader.hide()
    @music.once "error",       => @panel.loader.hide()

    return @music

