# Description:
#   Cute reactions to stuff
#
# Dependencies:
#   hubot-slack
#   hubot-slack-reaction
#
# Environment:
#   None
#
# Commands:
#   None

module.exports = (robot) ->
  robot.hear /(love you penny|penny love you|luff penny|love :penny:|love you :penny:)/i, (msg) ->
    robot.emit 'slack.reaction',
    message: msg.message
    name: 'heart'

  robot.hear /kamina/i, (msg) ->
    robot.emit 'slack.reaction',
    message: msg.message
    name: 'kamina'
  robot.hear /(penny I hate you|I hate penny)/i, (msg) ->
    robot.emit 'slack.reaction',
    message: msg.message
    name: 'fu'
