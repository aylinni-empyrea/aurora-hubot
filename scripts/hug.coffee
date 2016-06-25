# Description:
#   Penny hugs.
#
# Author:
#   bhankus -base
#   Lillnex - dialogue writing

module.exports = (robot) ->

  robot.hear /hug me penny|penny hug me|I needs? a hug|someone hug me/i, (res) ->

   res.send "_hugs #{res.message.user.name} _:hugging_face: :heart:"

