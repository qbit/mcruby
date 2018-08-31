# Base class for all plugins
class Plugin
  @@botname = 'mcchunkie'

  # determine if a message is for us
  def relevant?(msg)
    return false unless msg.match(@@botname)
    true
  end

  # gets rid of various things
  def msg_clean(msg, regex, replace)
    msg.gsub! regex, replace
    msg.strip
    msg.lstrip!
  end

  # decides if a message is response worthy or not
  def response(_to, from, msg)
    "'#{from} #{msg}', No!"
  end

  # pretty prints a hash for fields that match map
  def pp(resp, map)
    msg = []
    resp.each do |key, r|
      msg.push [map[key], r].join(': ') unless map[key].nil?
    end
    msg.join(', ')
  end

  # method called to run tests for a given plugin
  def test
    false
  end
end
