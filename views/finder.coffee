class PreviewFinder extends KDView
  webPrefix: ".kd.link"

  constructor: (options = {}, data) ->

    @vmController = KD.getSingleton "vmController"

    # clean olderfiles
    @cleanOlderFiles()

    super options, data

    @vmController.fetchDefaultVmName (vmName) =>
      @finder = new NFinderController
        nodeIdPath       : "path"
        nodeParentIdPath : "parentPath"
        contextMenu      : yes
        useStorage       : no
        bind             : "keydown"

      @addSubView @finder.getView()
      @finder.updateVMRoot vmName, "/home/#{KD.nick()}"

      @finder.on "FileNeedsToBeOpened", (file) =>
        @cleanOlderFiles()
        mainView = @getDelegate()
        mainView.emit "FileSelected", file


  cleanOlderFiles: ->
    @vmController.run "rm /home/#{KD.nick()}/Web/#{@webPrefix}*"

