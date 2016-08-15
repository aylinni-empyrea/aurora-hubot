# Description:
#   Get the top voter list from terraria-servers.com
#
# Dependencies:
#   request
#
# Configuration:
#   HUBOT_TERRARIASERVERS_API_KEY: Your API key
#
# Commands:
#   penny who are the top voters (of {this|current,last|previous} month) _default: this month_
#
# Author:
#   deadsurgeon42
#

request = require 'request'

monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
]

###################################################################################################

config =
  limit: 5
  default_month: 'current'
  # Footer is only appended to this month calls
  url: "https://terraria-servers.com/api/"
  qs:
    object: "servers"
    element: "voters"
    key: process.env.HUBOT_TERRARIASERVERS_API_KEY
    format: "json"
  msg:
    vote_url: 'https://bit.ly/vote4aurora'
    footer: """
            :exclamation: The top voter of each month will receive the exclusive *[Top Voter]* rank!
            See https://aurora-terraria.org/threads/voting-top-voter-rank.4909/ for more details.
            """

###################################################################################################

config.qs.limit = config.limit

module.exports = (robot) ->

  robot.respond /who are the top voters(.*)?/i, (res) ->

    if config.qs.key is null or undefined
      res.send "[ERROR] HUBOT_TERRARIASERVERS_API_KEY not defined"
      return
    if /last|previous/i.test res.match[0]
      month = 'previous'
    else if /this|current/i.test res.match[0]
      month = 'current'
    else
      month = config.default_month

    qs = config.qs
    qs.month = month

    request.get {
      url: config.url
      json: true
      qs: qs
    }, (e, r, b) ->

      if e?
        res.send "Whoops, something terrible happened! #{e.statusCode}"
        return

      year = b.month.substring(0, 4)
      month_absolute = parseInt (b.month.substring(4, 6))

      _voters = []

      for voter in b.voters
        _voters.push("#{voter.nickname}: #{voter.votes}")
        _voters_fmt = _voters.join("\n")

      z =
        channel: res.message.room || res.envelope.room
        unfurl_links: false
        attachments: [
                  title: "The top #{config.limit} voters of #{month} month:"
                  fallback: _voters_fmt
                  text: _voters_fmt
                ,
                  text: ":star: Vote for us over at #{config.msg.vote_url}! :star:"
                  fallback: "Vote for us over at #{config.msg.vote_url}!"
                  color: '#40ff40'
                ,
                  color: '#ff9940'
                  mrkdwn_in: ["text"]
                  fallback: 'More info at Aurora forums!'
                  text: config.msg.footer
                  ]

      res.send z
