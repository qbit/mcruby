require './plugins/plugins.rb'

# When a table is flipped, we need to put it back so it can be flipped again.
class PutItBack < Plugin
  def response(_to, _from, msg)
    '┬──┬﻿ ¯_(ツ)' if msg =~ /@tableflip/
  end

  def test
    resp = response('test', 'test', '@tableflip')
    resp = resp.chomp
    resp == '┬──┬﻿ ¯_(ツ)'
  end
end
