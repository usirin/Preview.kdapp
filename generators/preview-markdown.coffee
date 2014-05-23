class PreviewMarkdown extends BaseFile

  create: (src, file) ->
    @file.fetchContents().then (resolve, reject) =>
      @element = new KDCustomHTMLView
        cssClass : "markdown"
        partial : KD.utils.applyMarkdown resolve

      KD.utils.defer => @panel.loader.hide()

      return @element

  link: ->
    return new Promise (resolve, reject) =>
      resolve @create()

