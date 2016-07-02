# Description:
#   Hubot delivers a dank meme from Reddit's /r/montageparodies frontpage
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot mlg (me)- Find a dank meme from /r/montageparodies
#
# Author:
#   eliperkins

url = require("url")

module.exports = (robot) ->
  robot.respond /mlg( me)?/i, (msg) ->
    search = escape(msg.match[1])
    msg.http('https://www.reddit.com/r/montageparodies/top/week.json?limit=100')
      .get() (err, res, body) ->
        result = JSON.parse(body)

        urls = [ ]
        for child in result.data.children
          if child.data.domain != "self.montageparodies"
            urls.push(child.data.url)

        if urls.count <= 0
          msg.send "Couldn't find anything dank..."
          return

        rnd = Math.floor(Math.random()*urls.length)
        picked_url = urls[rnd]

        msg.send url.format(picked_url)
