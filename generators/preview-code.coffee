class PreviewCode extends BaseFile

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
        console.log "aceReady"

      @aceHolder.addSubView @ace

      return [@aceHolder]

  link: ->
    return new Promise (resolve, reject) =>
      resolve @create()

  prepareEditor: (content) ->
    { editor } = @ace
    editor.setValue content

    editor.setOption "scrollPastEnd", no

    editor.setFontSize 16

    editor.renderer.setPadding 10

    editor.clearSelection()

    editor.setHighlightActiveLine no
    editor.renderer.setShowGutter no
    editor.blur()

