class PreviewView extends JView
  constructor: (options = {}, data) ->
    options.cssClass = "preview-panel"
    super options, data
    @createPlaceholder()
    @loader = new KDLoaderView
      size: { width: 48 }

    @item = []

    @registerEvents()

    KD.utils.defer => @addSubView @loader

  registerEvents: ->
    @on "EditorActivated"   , @bound "enableEditMode"
    @on "EditorDeactivated" , @bound "disableEditMode"

  destroyAll: ->
    @loader.show()
    for item in @item
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
        @placeholder.addSubView item

  enableEditMode: ->
    @buttonGroup.buttons["Edit"].disable()
    @buttonGroup.buttons["Save"].enable()
    @buttonGroup.buttons["Cancel"].enable()

  disableEditMode: ->
    @buttonGroup.buttons["Edit"].enable()
    @buttonGroup.buttons["Save"].disable()
    @buttonGroup.buttons["Cancel"].disable()

  createButtonGroup: (options) ->
    { delegate } = options

    @buttonGroup   = new KDButtonGroupView
      cssClass     : "button-group"
      buttons      :
        "Edit"     :
          cssClass : "clean-gray"
          callback : =>
            @enableEditMode()
            delegate.emit "EditButtonClicked"
        "Save"     :
          cssClass : "clean-gray"
          disabled : yes
          callback : =>
            @disableEditMode()
            delegate.emit "SaveButtonClicked"
        "Cancel"   :
          cssClass : "clean-gray"
          disabled : yes
          callback : =>
            @disableEditMode()
            delegate.emit "CancelButtonClicked"

    @addSubView @buttonGroup

  generate: (options) ->
    { generator, file } = options
    @destroyAll()

    file.fetchRawContents().then (resolve, reject) =>
      (instance = new generator resolve.content, file, this).generate().then (item) =>
        if generator.editable
        then @createButtonGroup(delegate: instance)
        else @buttonGroup?.hide()

        @item = if (Array.isArray item) then item else [item]
        @addAll()
    , (err) => # this happens when a file size is over 10MiB
      (instance = new generator null, file, this).generate().then (item) =>
        if generator.editable
        then @createButtonGroup(delegate: instance)
        else @buttonGroup?.hide()

        @item = if (Array.isArray item) then item else [item]
        @addAll()

