isImage = (file) -> _.contains ["jpg", "gif", "png"], file.getExtension()
isPdf   = (file) -> file.getExtension() is "pdf"
isMusic = (file) -> file.getExtension() is "mp3"
isVideo = (file) -> _.contains ["mp4", "ogg"], file.getExtension()

