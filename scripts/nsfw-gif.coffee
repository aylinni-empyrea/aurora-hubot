# Description:
#   Hubot delivers a pic from Reddit's /r/nsfw_gif frontpage
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot nsfw gif - Display the picture from /r/aww
#
# Author:
# newera
#   eliperkins

url = require("url")

module.exports = (robot) ->
  robot.respond /nsfw gif/i, (msg) ->
    search = escape(msg.match[1])
    msg.http('https://www.reddit.com/user/RyanSammy/m/gifs/top.json?t=week?limit=100')
      .get() (err, res, body) ->
        result = JSON.parse(body)

        urls = [ ]

        if msg.message.room != "nsfw" and msg.message.room != "porn"
         msg.send "Sorry, I can't post anything nsfw here!"
         return

        for child in result.data.children
          if child.data.domain != "self.nsfw_gif"
            urls.push(child.data.url)

        if urls.count <= 0
          msg.send "Couldn't find anything cute..."
          return

        rnd = Math.floor(Math.random()*urls.length)
        picked_url = urls[rnd]

        parsed_url = url.parse(picked_url)
#        if parsed_url.host == "imgur.com"
#          parsed_url.host = "i.imgur.com"
#          parsed_url.pathname = parsed_url.pathname + ".gif"
#
#          picked_url = url.format(parsed_url)
        
        # switch parsed_url.host
            # when "imgur.com"
                # parsed_url.host = "i.imgur.com"
                # parsed_url.pathname = parsed_url.pathname + ".gif"
            # when "gfycat.com"
                # parsed_url.host = "giant.gfycat.com"
                # parsed_url.pathname = parsed_url.pathname + ".gif"
                
        picked_url = url.format(parsed_url)
        msg.send picked_url
