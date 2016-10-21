# Description:
#
#  Sets window title to HUBOT_NAME
#
# Configuration:
#
#  HUBOT_NAME
#

module.exports = (robot) -> process.title = process.env.HUBOT_NAME
