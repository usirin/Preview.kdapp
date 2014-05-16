class PreviewVideo
  constructor: (@src, @video, @panel) ->
    { @vmController } = KD.singletons
    @mime = "video/#{@video.getExtension()}"

  generate: ->
    return @linkVideo()

  linkVideo: ->
    path = FSHelper.plainPath @video.path
    linkName = "kd.video-link.#{KD.utils.getRandomNumber(1e21)}.#{@video.getExtension()}"
    destinationPath = "/home/#{KD.nick()}/Web/#{linkName}"
    @vmController.run("ln -s #{path} #{destinationPath}").then (resolve) =>
      webPath = "//#{KD.nick()}.kd.io/#{linkName}"
      @create(webPath)

  base64Src: (src) ->
    "data:#{@mime};base64,#{@src}"

  create: (src, video) ->
    src ||= @base64Src()
    @video       = new KDCustomHTMLView
      tagName    : "video"
      cssClass   : "preview-video"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true
        width    : "auto"
        height   : "auto"

    @video.once "loadeddata",  => @panel.loader.hide()
    @video.once "error",       => @panel.loader.hide()

    return @video

