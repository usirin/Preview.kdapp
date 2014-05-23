class PreviewCode extends BaseFile

  create: (src, file) ->
    @file.fetchContents().then (resolve, reject) =>
      console.log(hljs.highlightAuto resolve)
      @element   = new KDCustomHTMLView
        tagName  : "pre"
        cssClass : "code"

      content = PreviewHelpers.prettifyJson resolve, @file.getExtension()

      @element.addSubView new KDCustomHTMLView
        tagName : "code"
        partial : hljs.highlightAuto(content).value

      KD.utils.defer => @panel.loader.hide()

      return @element

  link: ->
    return new Promise (resolve, reject) =>
      resolve @create()
