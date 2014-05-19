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
                type          : "split"
                name          : "InnerSplit"
                options       :
                  direction   : "horizontal"
                  sizes       : [null, "150px"]
                views         : [
                  {
                    type      : "custom"
                    name      : "preview"
                    paneClass : PreviewView
                  }
                  {
                    type      : "custom"
                    name      : "details"
                    paneClass : PreviewDetails
                  }
                ]
              }
            ]
        ]

      @workspace.once "viewAppended", =>
        @bindWorkspaceEvents()

      KD.utils.defer => @addSubView @workspace

  bindWorkspaceEvents: ->
    @panel = @workspace.getActivePanel()
    {@finder, @preview, @details} = @panel.panesByName

    @panel.on "ImageSelected", (file) => @preview.generate generator: PreviewImage, file: file
    @panel.on "MusicSelected", (file) => @preview.generate generator: PreviewMusic, file: file
    @panel.on "VideoSelected", (file) => @preview.generate generator: PreviewVideo, file: file

    @panel.on "FileSelected",  (file) => @details.update file

