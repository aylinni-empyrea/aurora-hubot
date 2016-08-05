# Description:
#   A way to interact with the Google Images API through freeloaderism, use at your own risk
#
# Configuration
#   HUBOT_GOOGLE_CSE_KEY - Your Google developer API key
#   HUBOT_GOOGLE_CSE_ID - The ID of your Custom Search Engine
#   HUBOT_GOOGLE_SAFE_SEARCH - Optional. Search safety level.
#   HUBOT_GOOGLE_IMAGES_FALLBACK_ID && HUBOT_GOOGLE_IMAGES_FALLBACK_KEY && HUBOT_GOOGLE_IMAGES_FALLBACK_PROXY
#
# Dependencies:
#   request
#
# Commands:
#   hubot image me <query> - The Original. Queries Google Images for <query> and returns a random top result.
#   hubot animate me <query> - The same thing as `image me`, except adds a few parameters to try to return an animated GIF instead.

request = require 'request'

#acceptedColors = [ 'black', 'blue', 'brown', 'gray', 'green', 'pink', 'purple', 'teal', 'white', 'yellow' ]

nsfw_rooms = ['nsfw']

random = (a) -> return a[Math.floor(Math.random() * a.length)]

pullAFast = (url, q, id, key, proxy, cb, animated) ->
  console.log '[googletricks.coffee] WARN: shit the cops got us, gotta trick google'
  if !id? || !key? || !proxy?
    console.log '[googletricks.coffee] ERROR: fallback variables improperly configured'
    return 'Configuration error'
  else
    q.key = key
    q.cx = id

    request ({
      url: url
      qs: q
      proxy: proxy
      }), (err, res, body) ->

        #console.log random(JSON.parse(body).items).link
        cb ensureResult random(JSON.parse(body).items).link, animated

module.exports = (robot) ->

  robot.respond /(?:image|img)(?: me)? (.+)/i, (msg) ->
    imageMe msg, msg.match[1], (url) ->
      msg.send url

  robot.respond /animate(?: me)? (.+)/i, (msg) ->
    imageMe msg, msg.match[1], true, (url) ->
      msg.send url

imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated is 'function'
  cb = faces if typeof faces is 'function'

  googleCseId = process.env.HUBOT_GOOGLE_CSE_ID
  if googleCseId
    # Using Google Custom Search API
    googleApiKey = process.env.HUBOT_GOOGLE_CSE_KEY
    if !googleApiKey
      msg.robot.logger.error "Missing environment variable HUBOT_GOOGLE_CSE_KEY"
      msg.send "Missing server environment variable HUBOT_GOOGLE_CSE_KEY."
      return
    q =
      q: query,
      searchType:'image',
      safe: process.env.HUBOT_GOOGLE_SAFE_SEARCH || 'high',
      fields:'items/link',

    if animated is true
      q.fileType = 'gif'
      q.hq = 'animated'
      q.tbs = 'itp:animated'
    if faces is true
      q.imgType = 'face'

    url = 'https://www.googleapis.com/customsearch/v1'

    q.cx = googleCseId
    q.key = googleApiKey

    q.safe = 'off' if msg.message.room in nsfw_rooms

    opts =
      qs: q
      url: url

    request opts, (err, res, body) ->
      switch res.statusCode
        when 403
          msg.send "Whoopsie, daily search limit exceeded! :confounded:"
          ###
          pullAFast url,
                    q,
                    process.env.HUBOT_GOOGLE_IMAGES_FALLBACK_ID,
                    process.env.HUBOT_GOOGLE_IMAGES_FALLBACK_KEY,
                    process.env.HUBOT_GOOGLE_IMAGES_FALLBACK_PROXY,
                    cb,
                    animated
          ###
        when 200
          cb ensureResult random(JSON.parse(body).items).link, animated

        else
          msg.send "Terrible things happened! #{res.statusCode}"

  else
    msg.send "Google Image Search API is no longer available. " +
      "Please [setup up Custom Search Engine API](https://github.com/hubot-scripts/hubot-google-images#cse-setup-details)."
    deprecatedImage(msg, query, animated, faces, cb)

deprecatedImage = (msg, query, animated, faces, cb) ->
  # Show a fallback image
  imgUrl = process.env.HUBOT_GOOGLE_IMAGES_FALLBACK ||
    'http://i.imgur.com/CzFTOkI.png'
  imgUrl = imgUrl.replace(/\{q\}/, encodeURIComponent(query))
  cb ensureResult(imgUrl, animated)

# Forces giphy result to use animated version
ensureResult = (url, animated) ->
  if animated is true
    ensureImageExtension url.replace(
      /(giphy\.com\/.*)\/.+_s.gif$/,
      '$1/giphy.gif')
  else
    ensureImageExtension url

# Forces the URL look like an image URL by adding `#.png`
ensureImageExtension = (url) ->
  if /(png|jpe?g|gif)$/i.test(url)
    url
  else
    "#{url}#.png"
