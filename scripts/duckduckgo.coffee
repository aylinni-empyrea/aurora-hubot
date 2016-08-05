request = require 'request'
truncate = require 'truncate'

o =
  uri: 'https://api.duckduckgo.com'
  qs:
    t: 'Hubot'
    format: 'json'
    no_html: 1
    skip_disambig: 1

module.exports = (robot) ->
  robot.respond /define(?: me)? (.*)/i, (res) ->

    if res.match[1] is "" or undefined
      res.send "Uhh, you gotta tell me _what_ to define :neutral_face:"

    else
      o.qs.q = res.match[1]

      request.get o, (e, r, b) ->
        result = JSON.parse b

        if result.Abstract isnt "" or undefined
          ret =
            attachments: [
              #mrkdwn_in: ["text", "pretext", "fields"]
              color: "#DE4D26"

              title: result.Heading
              title_link: result.AbstractURL

              fallback: truncate(result.AbstractText, 40)
              text: result.AbstractText

              footer: "Powered by #{result.AbstractSource} & DuckDuckGo.com"
              footer_icon: 'https://duckduckgo.com/favicon.ico'

            ]

          if result.Infobox.content
            ret.attachments[0].fields = []

            for field in result.Infobox.content
              z =
                title: field.label
                value: truncate(field.value, 180)
                short: true

              ret.attachments[0].fields.push z

          robot.emit 'slack.attachment', {
            channel: res.message.room || res.envelope.room
            content: ret.attachments
          }

        else
          res.send """
                  I'm sorry, couldn't find anything about \"#{res.match[1]}\".
                  Please keep in mind that DuckDuckGo Instant Search API is still WIP, and not very reliable.
                  """
