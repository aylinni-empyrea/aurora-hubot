#!/usr/bin/sh

## general options

HUBOT_LOG_LEVEL='debug'

## slack related

HUBOT_ADAPTER='slack'
HUBOT_SLACK_TOKEN='xoxb-49962470917-gyJ35cOqBOKgyaf2Pqnh89oI'
HUBOT_SLACK_EXIT_ON_DISCONNECT='true'

## brain

HUBOT_FILE_BRAIN_PATH='brain.db'

## google shit

HUBOT_GOOGLE_CSE_ID='015555699567081181253:x_vzxgf5kio'
HUBOT_GOOGLE_CSE_KEY='AIzaSyDhh4v1GrAxHOafixcrAO1RYDKp_zan4bk'
HUBOT_GOOGLE_SAFE_SEARCH='high'

## youtube

HUBOT_YOUTUBE_API_KEY='AIzaSyDhh4v1GrAxHOafixcrAO1RYDKp_zan4bk'
HUBOT_YOUTUBE_DETERMINISTIC_RESULTS='true'

## imgur

HUBOT_IMGUR_CLIENTID='f4facc7cbb59177'

## auth.coffee admins: @newy @patrikk @clay @lillnex @clara

HUBOT_AUTH_ADMIN='U04AMBT11,U0489BMSF,U1AL663F0,U0489C5N9,U048H7R95'

exec bin/hubot
