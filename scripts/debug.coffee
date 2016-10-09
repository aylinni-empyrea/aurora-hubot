# Description:
#   Log the 'msg' object

module.exports = (robot) ->
  unless process.env.HUBOT_LOG_LEVEL? and process.env.HUBOT_LOG_LEVEL is 'debug'
    return
  robot.respond /msgdebug(.*)?/i, (msg) -> robot.logger.debug msg
