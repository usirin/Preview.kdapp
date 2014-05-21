class PreviewDetails extends JView
  constructor: (options={}, data) ->
    options.cssClass = "preview-details"
    super options, data
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

  update: (file) ->
    @file = file
    @updateView()

  pistachio: ->
    """
    {{> @nameView }}
    {{> @sizeView }}
    {{> @dateView }}
    """

  updateView: ->
    { formatDate } = PreviewHelpers
    @nameView.show().updateData { propData: @file.name }
    @sizeView.show().updateData { propData: KD.utils.formatBytesToHumanReadable @file.size }
    @dateView.show().updateData { propData: formatDate @file.createdAt }

