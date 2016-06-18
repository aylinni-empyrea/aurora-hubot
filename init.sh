#!/usr/bin/sh

## general options
export HUBOT_LOG_LEVEL='debug'

## slack related
export HUBOT_ADAPTER='slack'
export HUBOT_SLACK_TOKEN='xoxb-49962470917-gyJ35cOqBOKgyaf2Pqnh89oI'
export HUBOT_SLACK_EXIT_ON_DISCONNECT='true'

## brain

export HUBOT_FILE_BRAIN_PATH='~/arc-penny/brain.db'

## google shit

export HUBOT_GOOGLE_CSE_ID='015555699567081181253:x_vzxgf5kio'
export HUBOT_GOOGLE_CSE_KEY='AIzaSyDhh4v1GrAxHOafixcrAO1RYDKp_zan4bk'
export HUBOT_GOOGLE_SAFE_SEARCH='high'

## youtube

export HUBOT_YOUTUBE_API_KEY='AIzaSyDhh4v1GrAxHOafixcrAO1RYDKp_zan4bk'
export HUBOT_YOUTUBE_DETERMINISTIC_RESULTS='true'

## imgur

export HUBOT_IMGUR_CLIENTID='f4facc7cbb59177'

## auth.coffee admins: @newy @patrikk @clay @lillnex @clara

export HUBOT_AUTH_ADMIN='U04AMBT11,U0489BMSF,U1AL663F0,U0489C5N9,U048H7R95'

exec bin/hubot
