require './plugins/plugins.rb'

# BotSnack when someone high5s us
class BotSnack < Plugin
  @@snacks = [
    'omm nom nom nom',
    '*puke*',
    'MOAR!',
    '=.='
  ]
  def response(_to, _from, msg)
    return unless relevant?(msg)
    return @@snacks[rand(0..@@snacks.length)] if msg =~ %r{botsnack}x
    nil
  end

  def test
    true
  end
end
