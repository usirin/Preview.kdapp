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

    @previewArea.forwardEvent @panel, "FileSelected"

