class PreviewView extends JView
  constructor: (options = {}, data) ->
    options.cssClass = "preview-panel"
    super options, data
    @createPlaceholder()
    @loader = new KDLoaderView
      size: { width: 48 }

    KD.utils.defer => @addSubView @loader

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

    KD.utils.defer =>
      @addSubView @placeholder
      @placeholder.hide()

  addAll: ->
    KD.utils.defer =>
      @placeholder.show()
      @placeholder.addSubView @item
      @placeholder.addSubView @name

  generate: (options) ->
    { generator, file } = options
    @destroyAll()

    file.fetchRawContents().then (resolve, reject) =>
      (new generator resolve.content, file, this).generate().then (item) =>
        @item = item
        @createName file.name
        @addAll()
    , (err) =>
      (new generator null, file, this).generate().then (item) =>
        @item = item
        @createName file.name
        @addAll()

