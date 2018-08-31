require './plugins/plugins.rb'
require 'linnaeus'

# determine if a message is joke worthy
class TWTS < Plugin
  @@lt = Linnaeus::Trainer.new
  @@lc = Linnaeus::Classifier.new
  @@msgs = []
  @@responses = [
    "ohlol, that's what he said!",
    "ohlol, that's what she said!",
    "ohlol, that's what they said!",
    "that's what he said!",
    "that's what she said!",
    "that's what they said!",
    ' - Brazzers',
    '( ͡ʘ ͜ʖ ͡ʘ)',
    'PHRASING, BOOM!',
    'TWHS!',
    'TWTS!',
    'ew! you guys are sick!',
    'go on...',
    'heuheuhuheuheuhe',
    'if you know what I mean.',
    'phrasing.',
    'twhs!',
    'twss!',
    'twts!'
  ]

  def response(_to, _from, msg)
    # Always store our incoming messages
    @@msgs.push msg

    # Classify our msg
    msg_class = @@lc.classify msg
    prev_msg = @@msgs[@@msgs.length - 2]

    @@msgs.shift if @@msgs.length > 5

    rval = rand(0..@@responses.length)

    if msg =~ %r{^twss$|^twhs$|^twts$}
      puts "Adding '#{prev_msg}' to the funny list"
      @@lt.train 'funny', prev_msg
      return "added '#{prev_msg}'"
    end

    if relevant?(msg)
      if msg =~ %r{no$}i
        @@lt.train 'notfunny', prev_msg
        puts "marking '#{prev_msg}' as notfunny."
        return "Sorry: '#{prev_msg}' isn't as funny as I had thought."
      end
    end

    @@responses[rval] if msg_class == 'funny'
  end

  def test
    # no tests yet
    true
  end
end
