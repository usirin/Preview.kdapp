class PreviewFile extends BaseFile

  fontAwesomeLetter: (fileType) ->
    typeToLetterMap =
      code    : "&#xf1c9;"
      text    : "&#xf0f6;"
      archive : "&#xf1c6;"
      unknown : "&#xf016;"

    return typeToLetterMap[fileType]

  create: (src, file) ->
    extension = @file.getExtension()
    type = FSFile.getFileType extension

    faLetter = @fontAwesomeLetter type

    @element   = new KDCustomHTMLView
      tagName  : "div"
      cssClass : "file-thumb"
      partial  : faLetter
      bind     : "load error"

    KD.utils.defer => @panel.loader.hide()

    return @element

  # override this so that
  # it won't try to move file to apache
  # or something like that.
  link: ->
    return new Promise (resolve, reject) =>
      resolve @create()

