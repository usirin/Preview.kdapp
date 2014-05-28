##
# This class encapsulates common behaviour
# of specific filetype operations
#
# Methods need to be implemented by child classes are:
#
#   @mime()
#   @webPrefix()
#   @create()
##
class BaseFile extends KDObject

  @editable: no

  constructor: (@src, @file, @panel) ->
    super
    { @vmController } = KD.singletons
    @webPath = "/home/#{KD.nick()}/Web/"

  random: -> KD.utils.getRandomNumber 1e21

  mime: -> ""
  webPrefix: -> ""
  create: (src, file) -> no

  generate: ->
    return @link()

  link: ->
    path            = FSHelper.plainPath @file.path
    linkName        = "#{@webPrefix()}.#{@random()}.#{@file.getExtension()}"
    destinationPath = "#{@webPath}#{linkName}"

    @vmController.run("ln -s #{path} #{destinationPath}").then (resolve) =>
      publicPath = "//#{KD.nick()}.kd.io/#{linkName}"
      @create publicPath

  base64src: (src) ->
    "data:#{@mime()};base64,#{src}"

