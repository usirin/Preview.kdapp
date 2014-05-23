class PreviewArea extends KDView
  constructor: (options = {}, data) ->
    super options, data
    @addSubView @preview = new PreviewView
    @addSubView @details = new PreviewDetails

    @on "FileSelected",  (file) =>
      generator = @getGenerator file
      @preview.generate {generator, file}
      @details.update file

  getGenerator: (file) ->
    markdownExtensions = [
      "markdown"
      "mdown"
      "mkdn"
      "md"
      "mkd"
      "mdwn"
      "mdtxt"
      "mdtext"
      "text"
    ]

    ext = file.getExtension()
    generator = switch FSFile.getFileType ext
      when "image" then PreviewImage
      when "video" then PreviewVideo
      when "sound" then PreviewMusic
      when "code"  then PreviewCode
      else do ->
        if ext is "rb" then PreviewCode
        else if _.contains markdownExtensions, ext then PreviewMarkdown
        else PreviewFile

