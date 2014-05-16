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
        # is(Image|Music|Video) functions
        # comes from helpers.coffee
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
    panel = @getDelegate()
    panel.emit "VideoSelected", file

