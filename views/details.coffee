class PreviewDetails extends JView
  constructor: (options={}, data) ->
    options.cssClass = "preview-details"
    super options, data

  viewAppended: ->
    super
    @nameView  = new PreviewDetailsItem
      cssClass : "details-name"
    ,
      propName : "Name"

    @sizeView  = new PreviewDetailsItem
      cssClass : "details-size"
    ,
      propName : "Size"

    @dateView  = new PreviewDetailsItem
      cssClass : "details-date"
    ,
      propName : "Created"

    KD.utils.defer =>
      @addSubView @nameView
      @addSubView @sizeView
      @addSubView @dateView

  update: (file) ->
    @file = file
    @updateView()

  updateView: ->
    { formatDate } = PreviewHelpers
    @nameView.updateData { propData: @file.name }
    @sizeView.updateData { propData: KD.utils.formatBytesToHumanReadable @file.size }
    @dateView.updateData { propData: formatDate @file.createdAt }

