PreviewHelpers =
  isImage : (file) -> _.contains ["jpg", "gif", "png"], file.getExtension()
  isMusic : (file) -> _.contains ["mp3", "m4a", "ogg"], file.getExtension()
  isVideo : (file) -> _.contains ["mp4", "ogg"], file.getExtension()

  prettifyJson: (content, fileExtension) ->
    return content unless fileExtension is "json"
    content = JSON.parse content
    return JSON.stringify(content, undefined, 2)

  normalize: (number) ->
    if number < 10 then "0"+number else ""+number

  formatDate: (dateString) ->
    days = [
      "Sunday"
      "Monday"
      "Tuesday"
      "Wednesday"
      "Thursday"
      "Friday"
      "Saturday"
    ]

    months = [
      "January", "February", "March"
      "April", "May", "June"
      "July", "August", "September"
      "October", "November", "December"
    ]

    { normalize } = PreviewHelpers

    date        = new Date dateString
    day         = days[date.getDay()]
    month       = months[date.getMonth()]
    dateOfMonth = normalize date.getDate()
    year        = normalize date.getFullYear()
    hour        = normalize date.getHours()
    minute      = normalize date.getMinutes()

    return "#{day}, #{month} #{dateOfMonth}, #{year} at #{hour}:#{minute}"

