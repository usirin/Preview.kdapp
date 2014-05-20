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
    generator = switch FSFile.getFileType file.getExtension()
      when "image" then PreviewImage
      when "video" then PreviewVideo
      when "audio" then PreviewMusic
      else PreviewFile

