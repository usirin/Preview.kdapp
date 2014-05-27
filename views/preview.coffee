class PreviewView extends JView
  constructor: (options = {}, data) ->
    options.cssClass = "preview-panel"
    super options, data
    @createPlaceholder()
    @loader = new KDLoaderView
      size: { width: 48 }

    @item = []

    KD.utils.defer => @addSubView @loader

#   createName: (name) ->
#     @name.updatePartial name

  destroyAll: ->
    @loader.show()
    for item in @item
      console.log "silinen: #{item}"
      item.destroy()

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
      for item in @item
        console.log "eklenen: #{item}"
        @placeholder.addSubView item

  generate: (options) ->
    { generator, file } = options
    @destroyAll()

    file.fetchRawContents().then (resolve, reject) =>
      (new generator resolve.content, file, this).generate().then (item) =>
        console.log "fetchRowContent < 10 MiB"
        @item = if (Array.isArray item) then item else [item]
        @addAll()
    , (err) => # this happens when a file size is over 10MiB
      (new generator null, file, this).generate().then (item) =>
        console.log "fetchRowContent > 10 MiB"
        @item = if (Array.isArray item) then item else [item]
        @addAll()

