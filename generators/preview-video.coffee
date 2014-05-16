class PreviewVideo
  constructor: (@src, @video, @panel) ->
    { @vmController } = KD.singletons
    @mime = "video/#{@video.getExtension()}"
    @webPath = "/home/#{KD.nick()}/Web/"
    @webPrefix = ".kd.link-video"

  random: -> KD.utils.getRandomNumber(1e21)

  generate: ->
    return @linkVideo()

  linkVideo: ->
    path = FSHelper.plainPath @video.path
    linkName = "#{@webPrefix}.#{@random()}.#{@video.getExtension()}"
    destinationPath = "#{@webPath}#{linkName}"
    @vmController.run("ln -s #{path} #{destinationPath}").then (resolve) =>
      publicPath = "//#{KD.nick()}.kd.io/#{linkName}"
      @create(publicPath)

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
        autoplay : true
        width    : "auto"
        height   : "auto"

    @video.once "loadeddata",  => @panel.loader.hide()
    @video.once "error",       => @panel.loader.hide()

    return @video

