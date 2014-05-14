class PreviewView extends JView

  constructor: (options = {}, data) ->

    options.cssClass = "preview-panel"

    super options, data

    @createPlaceholder()

    @loader = new KDLoaderView
      size:
        width: 48

    KD.utils.wait 1, => @addSubView @loader

  createPlaceholder: ->
    @placeholder = new KDCustomHTMLView
      tagName: "div"
      cssClass: "preview-placeholder"

    KD.utils.wait 1, =>
      @addSubView @placeholder
      @placeholder.hide()

  createImage: (src, image) ->
    src = "data:image/jpeg;base64,#{src}"
    @img         = new KDCustomHTMLView
      tagName    : "img"
      cssClass   : "preview-img"
      bind       : "load error"
      attributes : { src }

    @imgName = new KDView
      cssClass: "preview-img-name"
      partial: "#{image.name}"

    @img.once "load",  => @loader.hide()
    @img.once "error", => @loader.hide()

    KD.utils.wait 1, =>
      @placeholder.show()
      @placeholder.addSubView @img
      @placeholder.addSubView @imgName

  createMusic: (src, music) ->
    src = "data:audio/mp3;base64,#{src}"
    @music       = new KDCustomHTMLView
      tagName    : "audio"
      cssClass   : "preview-music"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true

    @imgName = new KDView
      cssClass: "preview-img-name"
      partial: "#{music.name}"

    @music.once "loadeddata",  => @loader.hide()
    @music.once "error", => @loader.hide()

    KD.utils.wait 1, =>
      @placeholder.show()
      @placeholder.addSubView @music
      @placeholder.addSubView @imgName

  createVideo: (src, video) ->
    src = "data:video/mp4;base64,#{src}"
    @video       = new KDCustomHTMLView
      tagName    : "video"
      cssClass   : "preview-video"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true

    @imgName = new KDView
      cssClass: "preview-img-name"
      partial: "#{video.name}"

    @video.once "loadeddata",  => @loader.hide()
    @video.once "error", => @loader.hide()

    KD.utils.wait 1, =>
      @placeholder.show()
      @placeholder.addSubView @video
      @placeholder.addSubView @imgName

  generateImage: (image) ->
    @loader.show()
    @img?.destroy()
    @imgName?.destroy()
    @imgDetails?.destroy()
    @music?.destroy()
    @video?.destroy()

    image.fetchRawContents().then (resolve, reject) =>
      @createImage resolve.content, image

  generateMusic: (music) ->
    @loader.show()
    @img?.destroy()
    @imgName?.destroy()
    @imgDetails?.destroy()
    @music?.destroy()
    @video?.destroy()

    music.fetchRawContents().then (resolve, reject) =>
      @createMusic resolve.content, music

  generateVideo: (video) ->
    @loader.show()
    @img?.destroy()
    @imgName?.destroy()
    @imgDetails?.destroy()
    @music?.destroy()
    @video?.destroy()

    video.fetchRawContents().then (resolve, reject) =>
      @createVideo resolve.content, video


