require('./plugins/plugins.rb')

# Respond to hello
class Hello < Plugin
  def response(_to, from, msg)
    "Hello there, #{from}!!!" if /^hi$/i =~ msg
  end

  def test
    resp = response('test', 'test', 'Hi')
    resp = resp.chomp

    resp == 'Hello there, test!!!'
  end
end
