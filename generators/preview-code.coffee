class PreviewCode extends BaseFile

  constructor: (src, file, panel) ->
    super src, file, panel

    @on "EditButtonClicked"   , @bound "editButtonClicked"
    @on "SaveButtonClicked"   , @bound "saveButtonClicked"
    @on "CancelButtonClicked" , @bound "cancelButtonClicked"

  @editable: yes

  editButtonClicked: ->
    @enableEditor()

  saveButtonClicked: ->
    console.log "save clicked"
    @disableEditor()
    @requestSave()

  cancelButtonClicked: ->
    console.log "cancel clicked"
    @disableEditor()

  create: (src, file) ->
    @file.fetchContents().then (resolve, reject) =>

      content = PreviewHelpers.prettifyJson resolve, @file.getExtension()

      @aceHolder = new KDCustomHTMLView
        cssClass : "aceholder"

      @ace              = new Ace
        delegate        : this
        enableShortcuts : no
      , @file

      @ace.once "ace.ready", =>
        @prepareEditor content
        @panel.loader.hide()

      @ace.on "dblclick", =>
        @panel.emit "EditorActivated"
        @enableEditor()

      @aceHolder.addSubView @ace

      return [@aceHolder]

  link: ->
    return new Promise (resolve, reject) =>
      resolve @create()

  prepareEditor: (content) ->
    { editor } = @ace
    editor.setValue content

    editor.setOption "scrollPastEnd", no
    editor.getSession().setUseWrapMode yes

    editor.setFontSize 16

    editor.renderer.setPadding 10

    @disableEditor()

  enableEditor: ->
    @contentBeforeEdit = @ace.editor.getSession().getValue()
    @ace.setClass "ace-editable"

    { editor } = @ace

    editor.selectAll()
    editor.setHighlightActiveLine yes
    editor.renderer.setShowGutter yes

  disableEditor: ->
    @ace.unsetClass "ace-editable"

    { editor } = @ace

    editor.clearSelection()
    editor.setHighlightActiveLine no
    editor.renderer.setShowGutter no

  requestSave: ->
    file    = @getData()
    return  unless file
    content = @ace.editor.getSession().getValue()

    return if @contentBeforeEdit == content

    file.save content, (err)-> warn err  if err

