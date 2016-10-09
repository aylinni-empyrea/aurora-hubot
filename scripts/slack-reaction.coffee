# Description:
#   Send slack reactions with hubot
#

module.exports = (robot) ->

  react = (msg, emote) ->

    _payload =
      name: emote
      channel: msg.room
      timestamp: msg.id

    robot.adapter.client.web.reactions.add emote, _payload, (err, res) ->
      if err?
        robot.logger.error err
        return

      # coffeelint: disable=max_line_length
      robot.logger.debug "Sending reaction #{_payload.name} to message #{_payload.timestamp} in channel #{_payload.room}"

  robot.on 'slack.reaction', (msg, emote) -> react msg, emote
