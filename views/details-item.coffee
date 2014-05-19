class PreviewDetailsItem extends JView
  constructor: (options={}, data) ->
    options.cssClass = KD.utils.curry "details-item", options.cssClass
    super options, data

  itemTemplate: ->
    data = @getData()

    console.log data

    propName = data.propName || ""
    propData = data.propData || ""
    """
    <div class="prop">#{ propName }</div>
    <div class="prop-data">#{ propData }</div>
    <div style="clear: both"></div>
    """

  updateData: (data) ->
    return unless typeof data is "object"

    oldData = @getData()
    for key, value of data
      oldData[key] = value

    @setData oldData

    @renderTemplate()

  renderTemplate: ->
    @updatePartial @itemTemplate()

