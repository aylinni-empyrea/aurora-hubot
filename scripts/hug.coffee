# Description:
#   Penny hugs.
#
# Author:
#   bhankus -base
#   Lillnex - dialogue writing

module.exports = (robot) ->
  robot.hear /hug (\w*) penny|penny hug (\w*)|(\w*) needs? a hug|someone hug (\w*)/i, (res) ->
    if res.match is "me" or "I"
      res.send "_hugs #{res.message.user.name} _:hugging_face: :heart:"

    else res.send "_hugs #{res.match[1]} _:hugging_face: :heart:"
