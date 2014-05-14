class PreviewView extends JView
  constructor: (options = {}, data) ->
    options.cssClass = "preview-panel"
    super options, data
    @createPlaceholder()
    @loader = new KDLoaderView
      size: { width: 48 }

    KD.utils.wait 1, => @addSubView @loader

  createName: (name) ->
    @name = new KDView
      cssClass: "preview-img-name"
      partial: name

  destroyAll: ->
    @loader.show()
    @item?.destroy()
    @name?.destroy()

  createPlaceholder: ->
    @placeholder = new KDCustomHTMLView
      tagName: "div"
      cssClass: "preview-placeholder"

    KD.utils.wait 1, =>
      @addSubView @placeholder
      @placeholder.hide()

  addAll: ->
    KD.utils.wait 1, =>
      @placeholder.show()
      @placeholder.addSubView @item
      @placeholder.addSubView @name

  generateImage: (image) ->
    @destroyAll()
    image.fetchRawContents().then (resolve, reject) =>
      @item = new PreviewImage resolve.content, image, this
      @createName image.name
      @addAll()

  generateMusic: (music) ->
    @destroyAll()
    music.fetchRawContents().then (resolve, reject) =>
      @item = new PreviewMusic resolve.content, music, this
      @createName music.name
      @addAll()

  generateVideo: (video) ->
    @destroyAll()
    video.fetchRawContents().then (resolve, reject) =>
      @item = new PreviewVideo resolve.content, video, this
      @createName video.name
      @addAll()
