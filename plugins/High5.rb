require('./plugins/plugins.rb')

# High5 when someone high5s us
class High5 < Plugin
  def response(_to, _from, msg)
    return unless relevant?(msg)
    return '\o' if msg =~ %r{o\/}x
    return 'o/' if msg =~ %r{\\o}x
    'nerp'
  end

  def test
    resp = response('test', 'test', "#{@@botname}: o/")
    resp = resp.chomp
    return true if resp == '\o'
    false
  end
end
