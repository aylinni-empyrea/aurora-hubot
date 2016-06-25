# Description:
#   Penny responses.
#
# Author:
#   bhankus -base
#   Lillnex - dialogue writing
pennyiconQuotes = [
  "Someone here is combat ready! ",
  "Isn't that a one, cute, little robot?",
  "That's such a pretty one! :slightly_smiling_face:"
]
notificationQuotes = [
  "Yes?",
  "Did you call me?",
  "I'm listening.",
  "Hm?",
  "I'm ready.",
]
smileQuotes = [
  ":laughing:",
  ":slightly_smiling_face:",
  ":smile:",
  ":smiley:",
  ":blush:"
]
catfaceQuotes = [
  ":smiley_cat:",
  ":cat:",
  ":smirk_cat:",
  ":heart_eyes_cat:"
]
stopQuotes = [
  "Okay.",
  "I stopped.",
  "Alright."
]
loveQuotes = [
  ":heart_eyes_cat:",
  "Thank you :blush:",
]
likeQuotes = [
  "Thank you :blush:",
  "I like you too."
]
friendQuotes = [
  "Yes."
  "That is a yes."
  "But of course!",
  "That is correct",
  "Isn't that obvious, already?",
  "I love all of me friends and that includes you too.",
  "I'm always happy to hear that because I can answer yes!",
  "Yes and I hope to make a lot more friends in the future!"
]
cuteQuotes = [
  "Why, thank you!"
  "You make me feel happy!"
  ":3"
  ""
]

react = (res, reaction) ->
  robot.emit 'slack.reaction',
  message: res.message
  name: reaction

module.exports = (robot) ->

  robot.hear /:penny:$/i, (msg) ->
    msg.send msg.random pennyiconQuotes

  robot.hear /@penny/i, (msg) ->
    msg.send msg.random notificationQuotes

  robot.hear /penny stop|penny enough/i, (msg) ->
    msg.send msg.random stopQuotes

  robot.hear /penny smile/i, (msg) ->
    msg.send msg.random smileQuotes

  robot.hear /penny catface/i, (msg) ->
    msg.send msg.random catfaceQuotes

  robot.hear /penny I love you|I love you penny/i, (msg) ->
    msg.send msg.random loveQuotes
    react msg, 'heart_eyes_cat'

  robot.hear /penny I like you|I like you penny/i, (msg) ->
    msg.send msg.random likeQuotes
    react msg, 'kissing_cat'

  robot.hear /penny want to be friends|penny wanna be friends|penny are we friends|penny are you my friend|penny am i your friend|penny are we friends|penny are we your friends|penny are you our friend/i, (msg) ->
    msg.send msg.random friendQuotes
    react msg, 'hugging_face'

  robot.hear /penny is cute|penny is just so cute|penny is just too cute|penny is too cute|penny is cuter|penny is way cuter|"penny's just too cute"|penny is more cute|"penny's cuter"|"penny you're cute"|"penny you're so cute"|penny you are cute|penny you are so cute|penny you are just cute|penny you are just too cute|penny you are just so cute|"penny you're just cute"|"penny you're just too cute"|"you're cute penny"|"you're so cute penny"|you are cute penny|you are so cute penny|you are just cute penny|"you're just cute penny"|"you're just too cute penny"/i, (msg) ->
    msg.send msg.random cuteQuotes
    react msg, 'heart'
