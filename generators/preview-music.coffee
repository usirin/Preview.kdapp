class PreviewMusic extends BaseFile
  constructor: (@src, @music, @panel) ->
    super @src, @music, @panel

  mime: -> "audio/#{@music.getExtension()}"

  webPrefix: -> ".kd.link-music"

  create: (src, music) ->
    src ||= @base64Src()
    @music       = new KDCustomHTMLView
      tagName    : "audio"
      cssClass   : "preview-music"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true
        autoplay : true

    @music.once "loadeddata",  => @panel.loader.hide()
    @music.once "error",       => @panel.loader.hide()

    return @music

