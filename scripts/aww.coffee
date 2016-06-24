# Description:
#   Hubot delivers a pic from Reddit's /r/aww frontpage
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot aww - Display the picture from /r/aww
#
# Author:
#   eliperkins

url = require("url")

module.exports = (robot) ->
  robot.respond /aww/i, (msg) ->
    search = escape(msg.match[1])
    msg.http('https://www.reddit.com/user/sjxp/m/cutes.json?limit=100')
      .get() (err, res, body) ->
        result = JSON.parse(body)

        urls = [ ]
        for child in result.data.children
          if child.data.domain != "self.aww"
            urls.push(child.data.url)

        if urls.count <= 0
          msg.send "Couldn't find anything cute..."
          return

        rnd = Math.floor(Math.random()*urls.length)
        picked_url = urls[rnd]

        msg.send url.format(picked_url)
