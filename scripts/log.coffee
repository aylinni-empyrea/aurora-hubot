# Originally by NyxStudios/cardinal

fs = require 'fs'
{TextMessage} = require 'hubot'

ignoredRooms = (process.env.HUBOT_CHAT_LOG_IGNORED_ROOMS).split(",") || []

if process.env.HUBOT_CHAT_LOG_PATH?
  path = process.env.HUBOT_CHAT_LOG_PATH
else
  path = './'

if (fs.statSync path).isDirectory is false
  try
    fs.mkdirSync path
  catch e
    robot.logger.error "Error while creating directory:" + e

module.exports = (robot) ->
  receiveOrg = robot.receive

  robot.receive = (msg) ->
    if msg instanceof TextMessage
      room = robot.adapter.client.rtm.dataStore.getChannelGroupOrDMById(msg.user.room).name
      time = new Date(msg.id * 1000).toUTCString()
      user = msg.user.name

      if not robot.logBound?
        _ld = new Date()
        logDate = "#{_ld.getFullYear()}-#{_ld.getMonth() + 1}-#{_ld.getDate()}" # rotate daily
      else
        logDate = robot.logBound

      log = (text) ->
        return if room in ignoredRooms
        fs.appendFile(path + "#{logDate}_#{room}.log", "[#{time}] #{user}: #{text}\n", (err) ->
          if err
            console.log("Failed to write msg to log. #{user}> #{time}: #{text}")
        )

      log msg.text

    # this is required to make sure log lines
    # don't multiply when "penny reload" is used

    receiveOrg.bind(robot)(msg) unless robot.logBound?
    robot.logBound = logDate
