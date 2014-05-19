class PreviewArea extends KDView
  constructor: (options = {}, data) ->
    super options, data
    @preview = new PreviewView
    @details = new PreviewDetails

    @on "ImageSelected", (file) => @preview.generate generator: PreviewImage, file: file
    @on "MusicSelected", (file) => @preview.generate generator: PreviewMusic, file: file
    @on "VideoSelected", (file) => @preview.generate generator: PreviewVideo, file: file

    @on "FileSelected",  (file) => @details.update file

  viewAppended: ->
    super
    @addSubView @preview
    @addSubView @details

