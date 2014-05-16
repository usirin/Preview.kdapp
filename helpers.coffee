PreviewHelpers =
  isImage : (file) -> _.contains ["jpg", "gif", "png"], file.getExtension()
  isMusic : (file) -> _.contains ["mp3", "m4a", "ogg"], file.getExtension()
  isVideo : (file) -> _.contains ["mp4", "ogg"], file.getExtension()

