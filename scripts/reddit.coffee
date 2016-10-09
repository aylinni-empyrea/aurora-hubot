# Description:
#
#  Retrieves posts from a subreddit
#
# Configuration:
#
#  None
#
# Dependencies:
#
#  lib/reddit, async, truncate
#
# Commands:
#
#  hubot reddit (me) <subreddit> (random|number)

{parallel} = require 'async'
truncate = require 'truncate'
reddit = require '../lib/reddit.coffee'

module.exports = (robot) ->
  robot.respond /reddit(?: me)? (?:\/r\/)?(\w+) ?(\d+|random)?/i, (msg) ->

    console.log msg.match

    if msg.match[1] is 'me'
      msg.send "You should tell me which subreddit you want."
      return

    if msg.match[2] is 'random'
      count = 5 # default amount
    else if msg.match[2] is '' or msg.match[2] is undefined
      count = 1
    else
      count = msg.match[2]

    z = []

    for i in [ 1..count ]
      z.push (
        (done) ->
          reddit.getRandomPost "/r/#{msg.match[1]}", (a) ->

            done(e, null) if e?
            done(null, a)
      )

    parallel z, (e, r) ->
      console.log e if e?

      attachments = []
      for post in r

        _score = "#{post.score || '?'} points – "
        attachments.push {
          fallback: "#{post.title} – #{post.url} (#{post.score || '?'})"

          author_name: "/u/#{post.author}"

          title: post.title
          title_link: post.url

          mrkdwn_in: ['text']
          # coffeelint: disable=max_line_length
          text: truncate(post.selftext, 90) + " <#{post.url}|_read more →_>" if post.is_self is true
          # coffeelint: enable=max_line_length

          thumb_url: post.thumbnail if post.thumbnail?

          color: '#C6DDF6'

          footer: "#{_score}/r/#{post.subreddit} – reddit.com"
          footer_icon: 'https://www.reddit.com/favicon.ico'
        }

      msg.send {
        channel: msg.message.room || msg.envelope.room
        unfurl_links: false
        unfurl_media: false
        attachments: attachments
      }
###
    posts.join '\n'
    console.log posts
###
