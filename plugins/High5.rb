require './plugins/plugins.rb'

# High5 when someone high5s us
class High5 < Plugin
  def response(_to, _from, msg)
    return unless relevant?(msg)
    return '\o' if msg =~ %r{o\/}x
    return 'o/' if msg =~ %r{\\o}x
    'nerp'
  end

  def _comp_resp(mesg, comp)
    resp = response('test', 'test', mesg)
    resp = resp.chomp
    return true if comp == resp
    false
  end

  def test
    a = _comp_resp("#{@@botname}: o/", '\\o')
    b = _comp_resp("#{@@botname}: \\o", 'o/')
    abort("improper response for 'o/'") unless a
    abort("improper response for '\\o'") unless b
    return true if a && b
    false
  end
end
