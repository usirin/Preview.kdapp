class PreviewController extends AppController

  constructor: (options = {}, data) ->

    options.view    = new PreviewMainView

    options.appInfo =
      name : "Preview"
      type : "application"

    super options, data

