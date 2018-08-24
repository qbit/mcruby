require './plugins/plugins.rb'
require 'redis'

# Add / get protips
class ProTip < Plugin
  @@redis = Redis.new

  def response(_to, _from, msg)
    if msg =~ %r{^protip:|^brotip:}
      msg = msg_clean(msg, %r{^protip:|^brotip:}, '')
      @@redis.rpush('l_protips', msg)
      nil
    elsif msg =~ %r{^protip\?|^brotip\?}
      len = @@redis.llen('l_protips')
      idx = rand(0..len)
      return get_by_idx(idx)
    end

    vote_on(msg) if msg =~ %r{^\d+\+\+$|^\d+--$}
  end

  def get_id(mesg)
    mesg = mesg.gsub '++', ''
    mesg = mesg.gsub '--', ''
    mesg
  end

  def vote_on(msg)
    index = get_id(msg)
    vote = 1 if msg =~ %r{\+\+}
    vote = -1 if msg =~ %r{--}
    begin
      @@redis.hincrby('protip_votes', index, vote) if get_by_idx(index)
    rescue StandardError => e
      puts e.message
      return nil
    end
    nil
  end

  def get_by_idx(index)
    begin
      tip = @@redis.lindex('l_protips', index)
    rescue StandardError => e
      puts e.message
      return nil
    end
    count = @@redis.hget('protip_votes', index) || 0
    resp = "(#{count}:#{index}) #{tip}"
    resp
  end

  def test
    # no tests yet
    true
  end
end
