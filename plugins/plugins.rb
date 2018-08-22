# Base class for all plugins
class Plugin
  @@botname = 'mcchunkie'
  def relevant?(msg)
    return false unless msg.match(@@botname)
    true
  end

  def response(_to, from, msg)
    "'#{from} #{msg}', No!"
  end

  def test
    false
  end
end
