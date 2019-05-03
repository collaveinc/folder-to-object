
fg = require 'fast-glob'
{ relative, join, parse } = require 'path'

defaults =
  extensions: ['js', 'ts', 'coffee', 'json']

handleFiles = (dir, files) ->
  object = {}
  for file in files
    parsed = parse file
    tokens = relative(parsed.dir, dir).split('/')

    currentObject = object
    for token in tokens
      continue unless token
      currentObject = object[token] ?= {}

    currentObject[parsed.name] = require join process.cwd(), file

  return object

handleOpts = (opts) ->
  return dir: opts if 'string' is typeof opts
  return opts

sync = (opts) ->
  { dir, extensions = defaults.extensions } = handleOpts opts
  handleFiles dir, fg.sync join dir, "**/*.(#{extensions.join '|'})"

async = (opts) ->
  { dir, extensions = defaults.extensions } = handleOpts opts
  handleFiles dir, await fg.async join dir, "**/*.(#{extensions.join '|'})"

module.exports = { sync, async }
