isImage = (file) -> _.contains ["jpg", "gif", "jpg"], file.getExtension()
isPdf   = (file) -> file.getExtension() is "pdf"
isMusic = (file) -> file.getExtension() is "mp3"
isVideo = (file) -> _.contains ["mp4", "ogg"], file.getExtension()

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

    @panel.on "ImageSelected", (file) => @preview.generateImage file
    @panel.on "MusicSelected", (file) => @preview.generateMusic file
    @panel.on "VideoSelected", (file) => @preview.generateVideo file

class PreviewView extends JView

  constructor: (options = {}, data) ->

    options.cssClass = "preview-panel"

    super options, data

    @createPlaceholder()

    @loader = new KDLoaderView
      size:
        width: 48

    KD.utils.wait 1, => @addSubView @loader

  createPlaceholder: ->
    @placeholder = new KDCustomHTMLView
      tagName: "div"
      cssClass: "preview-placeholder"

    KD.utils.wait 1, =>
      @addSubView @placeholder
      @placeholder.hide()

  createImage: (src, image) ->
    src = "data:image/jpeg;base64,#{src}"
    @img         = new KDCustomHTMLView
      tagName    : "img"
      cssClass   : "preview-img"
      bind       : "load error"
      attributes : { src }

    @imgName = new KDView
      cssClass: "preview-img-name"
      partial: "#{image.name}"

    @img.once "load",  => @loader.hide()
    @img.once "error", => @loader.hide()

    KD.utils.wait 1, =>
      @placeholder.show()
      @placeholder.addSubView @img
      @placeholder.addSubView @imgName

  createMusic: (src, music) ->
    src = "data:audio/mp3;base64,#{src}"
    @music       = new KDCustomHTMLView
      tagName    : "audio"
      cssClass   : "preview-music"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true

    @imgName = new KDView
      cssClass: "preview-img-name"
      partial: "#{music.name}"

    @music.once "loadeddata",  => @loader.hide()
    @music.once "error", => @loader.hide()

    KD.utils.wait 1, =>
      @placeholder.show()
      @placeholder.addSubView @music
      @placeholder.addSubView @imgName

  createVideo: (src, video) ->
    src = "data:video/mp4;base64,#{src}"
    @video       = new KDCustomHTMLView
      tagName    : "video"
      cssClass   : "preview-video"
      bind       : "loadeddata error"
      attributes :
        src      : src
        controls : true

    @imgName = new KDView
      cssClass: "preview-img-name"
      partial: "#{video.name}"

    @video.once "loadeddata",  => @loader.hide()
    @video.once "error", => @loader.hide()

    KD.utils.wait 1, =>
      @placeholder.show()
      @placeholder.addSubView @video
      @placeholder.addSubView @imgName

  generateImage: (image) ->
    @loader.show()
    @img?.destroy()
    @imgName?.destroy()
    @imgDetails?.destroy()
    @music?.destroy()
    @video?.destroy()

    image.fetchRawContents().then (resolve, reject) =>
      @createImage resolve.content, image

  generateMusic: (music) ->
    @loader.show()
    @img?.destroy()
    @imgName?.destroy()
    @imgDetails?.destroy()
    @music?.destroy()
    @video?.destroy()

    music.fetchRawContents().then (resolve, reject) =>
      @createMusic resolve.content, music

  generateVideo: (video) ->
    @loader.show()
    @img?.destroy()
    @imgName?.destroy()
    @imgDetails?.destroy()
    @music?.destroy()
    @video?.destroy()

    video.fetchRawContents().then (resolve, reject) =>
      @createVideo resolve.content, video

class PreviewFinder extends KDView
  constructor: (options = {}, data) ->

    super options, data

    vmController = KD.getSingleton "vmController"
    vmController.fetchDefaultVmName (vmName) =>
      @finder = new NFinderController
        nodeIdPath       : "path"
        nodeParentIdPath : "parentPath"
        contextMenu      : yes
        useStorage       : no

      @addSubView @finder.getView()
      @finder.updateVMRoot vmName, "/home/#{KD.nick()}"

      @finder.on "FileNeedsToBeOpened", (file) =>
        @openImage file if isImage file
        @openMusic file if isMusic file
        @openVideo file if isVideo file

  openImage: (file) ->
    file.fetchContents (err, contents) =>
      if err
        return new KDNotificationView
          type     : "mini"
          cssClass : "error"
          title    : "Sorry, couldn't fetch file content, please try again..."
          duration : 3000

    panel = @getDelegate()
    panel.emit "ImageSelected", file

  openMusic: (file) ->
    file.fetchContents (err, contents) =>
      if err
        return new KDNotificationView
          type     : "mini"
          cssClass : "error"
          title    : "Sorry, couldn't fetch file content, please try again..."
          duration : 3000

    panel = @getDelegate()
    panel.emit "MusicSelected", file

  openVideo: (file) ->
    file.fetchContents (err, contents) =>
      if err
        return new KDNotificationView
          type     : "mini"
          cssClass : "error"
          title    : "Sorry, couldn't fetch file content, please try again..."
          duration : 3000

    panel = @getDelegate()
    panel.emit "VideoSelected", file

class PreviewController extends AppController

  constructor: (options = {}, data) ->

    options.view    = new PreviewMainView

    options.appInfo =
      name : "Preview"
      type : "application"

    super options, data


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
