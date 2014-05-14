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
                name          : "preview"
                paneClass     : PreviewView
              }
            ]
        ]

      @workspace.once "viewAppended", =>
        @bindWorkspaceEvents()

      KD.utils.wait 1, => @addSubView @workspace

  bindWorkspaceEvents: ->
    @panel = @workspace.getActivePanel()
    {@finder, @preview} = @panel.panesByName

    @panel.on "ImageSelected", (file) => @preview.generate generator: PreviewImage, file: file
    @panel.on "MusicSelected", (file) => @preview.generate generator: PreviewMusic, file: file
    @panel.on "VideoSelected", (file) => @preview.generate generator: PreviewVideo, file: file

