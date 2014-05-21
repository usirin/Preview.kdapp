class PreviewDetailsItem extends JView
  constructor: (options={}, data) ->
    options.cssClass = KD.utils.curry "details-item", options.cssClass
    data.propName ?= ""
    data.propData ?= ""
    super options, data
    @hide()

  pistachio: ->
    """
    <div class="prop">{{ #(propName) }}</div>
    <div class="prop-data">{{ #(propData) }}</div>
    <div style="clear: both"></div>
    """

  updateData: (data) ->
    return unless typeof data is "object"

    oldData = @getData()
    for key, value of data
      oldData[key] = value

    @setData oldData

