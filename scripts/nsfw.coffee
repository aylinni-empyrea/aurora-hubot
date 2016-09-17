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
#  url, cheerio, request
#
# Commands:
#
#  hubot nsfw pic
#  hubot gif
#  hubot wtf

url = require 'url'
cheerio = require 'cheerio'
request = require 'request'

random = (limit=100) -> Math.floor ( Math.random() * limit )

allowed_channels = process.env.HUBOT_NSFW_CHANNELS.split(',') if process.env.HUBOT_NSFW_CHANNELS?

module.exports = (robot) ->

  getRandomRedditPost = (msg, url) ->
    msg.http(url)
      .get() (err, res, body) ->

        if err
          msg.send 'Something bad happened!'
          throw new Error(err)

        result = JSON.parse(body)

        urls = [ ]

        subreddit = result.data.children[0].data.subreddit

        for child in result.data.children
          if child.data.domain != 'self.'+subreddit
            urls.push(
              {
                title: "*#{child.data.title}* – " || ''
                src: child.data.url
              }
            )

        if urls.count <= 0
          msg.send "Couldn't find anything? What's up reddit?"
          return

        msg.send urls[random(5)].title + urls[random(5)].src

  # waits for the string "hubot nsfw" or "hubot hook me up" to occur
  robot.respond /nsfw (pic|gif)/i, (msg) ->

    if allowed_channels isnt undefined and msg.message.room not in allowed_channels and msg.message.room[0] isnt 'D'
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
        getRandomRedditPost msg, 'https://www.reddit.com/user/RyanSammy/m/gifs/top.json?t=week&limit=100'

  robot.respond /kama(?: )sutra( of the week)?/i, (res) ->
    o =
      baseUrl: 'http://www.sofeminine.co.uk'
      qs: {}

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
