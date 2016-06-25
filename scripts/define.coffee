# Description:
# Get a definition from api.duckduckgo.com and post it as slack attachment
#
# Dependencies:
# hubot-slack
#
# Configuration:
# None
#
# Commands:
# hubot define (.*) - return the definition of the word/phrase
#
# Author:
# juan.ceron@pure360.com
#
getDefinition = (msg, query) ->
  msg.http("http://api.duckduckgo.com/?q=#{query}&format=json&t=hubot")
    .get() (err, res, body) ->
      results = JSON.parse body
      if results.Definition
        definition = results.Definition + '('
        if results.DefinitionSource
          definition += results.DefinitionSource + ' '
        msg.send definition
      else
        msg.send "Sorry, I couldn't find the meaning of #{query}"

module.exports = (robot) ->
  robot.respond /(define )(.*)/i, (msg) ->
    getDefinition msg, msg.match[2]
