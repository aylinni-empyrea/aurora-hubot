# Description:
#
#  Returns first result of google search
#
# Configuration:
#
#  None
#
# Dependencies:
#
#  request
#
# Commands:
#
#  hubot google (me) <string>

request = require 'request'
stub = 'https://www.google.com/search?btnI=&q='

module.exports = (robot) ->
  robot.respond /google(?: me) (.*)?/i, (msg) ->
    url = stub + encodeURIComponent(msg.match[1])

    request.get {url: url, followAllRedirects: true}, (e, r, b) ->
      if e
        robot.logger.error e
        return

      msg.send r.request.uri.href
