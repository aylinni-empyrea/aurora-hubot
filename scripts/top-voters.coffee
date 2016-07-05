# Description:
#   Get the top voter list from terraria-servers.com
#
# Dependencies:
#   None
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

config =
  max_voters: 5
  default_month: 'current'
  # Footer is only appended to this month calls
  footer: """
          Vote for us over at http://bit.ly/vote4aurora!
          > *Remember!* The top voter of each month will receive the exclusive *[Top Voter]* rank!

          See our forum for more details.
          """

check_url_stub = "https://terraria-servers.com/api/?object=servers&element=voters&key=#{process.env.HUBOT_TERRARIASERVERS_API_KEY}&format=json&limit=#{config.max_voters}"

module.exports = (robot) ->

  robot.respond /who are the top voters(.*)?( last| | previous| this)?( month)?/i, (msg) ->

    if /last|previous/i.test(msg.match[1]) is true
      check_url = check_url_stub + "&month=previous"
      month = 'previous'
    else
      check_url = check_url_stub + "&month=#{config.default_month}"
      month = 'this'

    robot.http(check_url)
      .get() (err, res, body) ->

        msg.send "Oops! #{err}" if err

        obj = JSON.parse body

        list_voters = (voters) ->

          voters_formatted = []

          for voter, index in voters
            voters_formatted.push "#{index + 1}. #{voter.nickname}: #{voter.votes}"

          final = """
                  *The top #{config.max_voters} voters of #{month} month:*
                  #{voters_formatted.join('\n')}
                  """

          if month is 'this'
            msg.send final + "\n\n" + config.footer
          else
            msg.send final

        list_voters obj.voters
