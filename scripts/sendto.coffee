# Description:
#   Send To
#
# Commands:
#

module.exports = (robot) ->

  robot.respond /say in\s+(\S+)\s+(.*)/i, (res) ->
   if res.message.room is "pennybot"
    room = res.match[1]
    message = res.match[2]

    robot.messageRoom room, message
