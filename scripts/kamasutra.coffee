cheerio = require 'cheerio'
request = require 'request'

o =
  baseUrl: 'http://www.sofeminine.co.uk'
  qs: {}

random = (limit=100) -> Math.floor ( Math.random() * limit )

module.exports = (robot) ->
  robot.respond /kama(?: )sutra( of the week)?/i, (res) ->

    if res.match[1] is 'of the week'
      o.uri = '/couple/newlovemach/positionsemaine.asp'
    else
      o.uri = '/couple/newlovemach/afficheflash.asp'
      o.qs = { position: random() }

    request.get o, (e, r, b) ->

      $ = cheerio.load b

      ret =
        attachments: [
          title: $(".lm_content .posTitle").text() || ''
          color: '#D37F97'
          text: $(".lm_content > p.text_intro").text()
          image_url: o.baseUrl + $(".lm_content .lm_posIllu > img").attr('src') || ''
        ]

      robot.emit 'slack.attachment', {
        channel: res.message.room || res.envelope.room
        content: ret.attachments
      }
