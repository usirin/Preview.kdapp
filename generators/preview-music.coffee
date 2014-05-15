class PreviewMusic
  constructor: (@src, @music, @panel) ->
    @mime = "audio/#{@music.getExtension()}"
    return new Promise (resolve, reject) =>
      resolve @create()

  base64Src: (src) ->
    "data:#{@mime};base64,#{@src}"

  create: (src, music) ->
    src = @base64Src()
    @music       = new KDCustomHTMLView
      tagName    : "audio"
      cssClass   : "preview-music"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true

    @music.once "loadeddata",  => @panel.loader.hide()
    @music.once "error",       => @panel.loader.hide()

    return @music

