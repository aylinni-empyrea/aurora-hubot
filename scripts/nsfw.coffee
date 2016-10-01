# Description:
#
#  Used to just grab a nsfw pic from titsnarse.co.uk but now does much more
#
# Configuration:
#
#  HUBOT_NSFW_CHANNELS: allow usage in <channel ids> only (optional)
#
# Dependencies:
#
#  lib/reddit
#
# Commands:
#
#  hubot nsfw pic
#  hubot nsfw gif

reddit = require '../lib/reddit.coffee'

allowed_channels = process.env.HUBOT_NSFW_CHANNELS.split(',') if process.env.HUBOT_NSFW_CHANNELS?

module.exports = (robot) ->

  robot.respond /nsfw (pic|gif)/i, (msg) ->

    if allowed_channels isnt undefined and msg.message.room[0] isnt 'D'
      msg.send "I can\'t post nsfw here!"
      return

    switch msg.match[1]
      when 'pic'
        # Configures the url of a remote server
        msg.http('http://titsnarse.co.uk/random_json.php')
          # and makes an http get call
          .get() (error, response, body) ->
            # passes back the image source
            msg.send 'http://titsnarse.co.uk' + JSON.parse(body).src

      when 'gif'

        reddit.getPosts ({
          subreddit: '/r/nsfw_gif'
          type: 'link'
          limit: 50
          sort: 'hot'
        }), (res) ->

          msg.send reddit.format( reddit.random(res) )

