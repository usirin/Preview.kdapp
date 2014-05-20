class PreviewVideo extends BaseFile
  constructor: (@src, @video, @panel) ->
    super @src, @video, @panel

  mime: -> "video/#{@video.getExtension()}"

  webPrefix: -> ".kd.link-video"

  create: (src, video) ->
    src ||= @base64Src()
    @video       = new KDCustomHTMLView
      tagName    : "video"
      cssClass   : "preview-video"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true
        autoplay : true
        width    : "auto"
        height   : "auto"

    @video.once "loadeddata",  => @panel.loader.hide()
    @video.once "error",       => @panel.loader.hide()

    return @video

