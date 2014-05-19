class PreviewMainView extends KDView
  constructor: (options = {}, data) ->
    super options, data

    KD.getSingleton("appManager").require "Teamwork", =>
      @workspace = new Workspace
        title                 : "Preview App"
        cssClass              : "preview-app"
        name                  : "Preview App"
        panels                : [
          title               : "Preview App"
          layout              :
            direction         : "vertical"
            sizes             : ["256px", null]
            splitName         : "BaseSplit"
            views             : [
              {
                type          : "custom"
                name          : "finder"
                paneClass     : PreviewFinder
              }
              {
                type          : "custom"
                name          : "previewArea"
                paneClass     : PreviewArea
              }
            ]
        ]

      @workspace.once "viewAppended", =>
        @bindWorkspaceEvents()

      KD.utils.defer => @addSubView @workspace

  bindWorkspaceEvents: ->
    @panel = @workspace.getActivePanel()
    {@finder, @previewArea} = @panel.panesByName

    @panel.on "ImageSelected", (file) => @previewArea.emit "ImageSelected", file
    @panel.on "MusicSelected", (file) => @previewArea.emit "MusicSelected", file
    @panel.on "VideoSelected", (file) => @previewArea.emit "VideoSelected", file

    @panel.on "FileSelected",  (file) => @previewArea.emit "FileSelected",  file

