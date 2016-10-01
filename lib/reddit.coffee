request = require 'request'

base = 'https://reddit.com'

random = (arr) ->

  _randint = (limit) -> Math.floor ( Math.random() * limit )
  return arr[_randint(arr.length)]

format = (obj) ->
  _score = "#{obj.score || '?'} points – "
  return "*#{obj.title}* – #{obj.url} – #{_score if obj.hide_score is false}by /u/#{obj.author}"

getPosts = (o, cb) -> # o: object of reddit api options + subreddit/multi name, cb(Array of links)

  throw new Error('Subreddit name must be given') unless o.subreddit?

  qs = Object.assign({}, o)
  delete qs.subreddit
  delete qs.sort if o.sort?
  delete qs.type if o.type?

  sort = o.sort || ''

  request.get {
    baseUrl: base
    url: o.subreddit + "/#{sort}" + '.json'
    qs: qs || undefined
    json: true
  }, (e, r, b) ->
    return if e?

    result = []

    for post in b.data.children
      unless post.data.stickied is true

        push = () -> result.push post.data

        switch o.type

          when 'self'
            push() if post.data.is_self is true

          when 'link'
            push() if post.data.is_self is false

          else
            push()

    cb result

getRandomPost = (sub, cb) ->

  throw new Error('Subreddit name must be given') unless sub?

  request.get {
    baseUrl: base
    url: sub + '/random.json'
    json: true
  }, (e, r, b) ->
    return if e?

    cb b[0].data.children[0].data

module.exports = {getPosts, getRandomPost, format, random}
