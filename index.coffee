isImage = (file) -> _.contains ["jpg", "gif", "jpg"], file.getExtension()
isPdf   = (file) -> file.getExtension() is "pdf"
isMusic = (file) -> file.getExtension() is "mp3"
isVideo = (file) -> _.contains ["mp4", "ogg"], file.getExtension()


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
