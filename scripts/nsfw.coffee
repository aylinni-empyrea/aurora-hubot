# Description:
#
#  Grab a nsfw pic from titsnarse.co.uk
#
# Dependencies:
#
#  none
#
# Commands:
#
#  hubot nsfw pic
#

module.exports = (robot) ->
  # waits for the string "hubot nsfw" or "hubot hook me up" to occur
  robot.respond /nsfw pic/i, (msg) ->
    if msg.message.room is "nsfw" or "porn"
      # Configures the url of a remote server
      msg.http('http://titsnarse.co.uk/random_json.php')
        # and makes an http get call
        .get() (error, response, body) ->
          # passes back the image source
          msg.send 'http://titsnarse.co.uk'+JSON.parse(body).src
    else
      msg.send 'I can\'t post nsfw here! :o'
