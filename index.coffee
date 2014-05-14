if appView?
  view = new PreviewMainView
  appView.addSubView view
else
  KD.registerAppClass PreviewController,
    name     : "Preview"
    routes   :
      "/:name?/Umlgenerator" : null
      "/:name?/usirin/Apps/Preview" : null
    dockPath : "/usirin/Apps/Umlgenerator"
    behavior : "application"
