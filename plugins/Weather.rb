require './plugins/plugins.rb'
require 'cgi'
require 'json'
require 'open-uri'
require 'redis'

# Looks up weather via openweathermap
class Weather < Plugin
  @@redis = Redis.new
  @@w_url = 'https://api.openweathermap.org/data/2.5/weather?APPID=%T'
  @@token = File.open('secrets/Weather') { |f| f.readline.chomp }

  def response(_to, from, msg)
    return unless msg =~ %r{^weather:}
    msg.gsub! 'weather:', ''
    msg = msg.strip
    msg = @@redis.get(from + '_weather') if msg == ''
    return 'nothing found, gimme a location info! nub.' if msg == '' || msg.nil?
    weather(from, msg)
  end

  def test
    w = response('test', 'test', 'weather: 81069')
    if w['id'] != 420_006_254
      w_dump = JSON.pretty_generate(w)
      abort("Invalid weather data: #{w_dump}")
    end
    true
  end

  def weather(from, location)
    url = loc_to_url(location)
    @@redis.set(from + '_weather', location) unless url.nil?
    url.gsub! '%S', CGI.escape(location)
    url.gsub! '%T', @@token
    uri = URI.parse(url)
    JSON.parse(uri.open.read)
  end

  private

  def loc_to_url(location)
    u = ''
    if location =~ %r{^\d+(,\w{2})?$}
      u = '&zip=%S'
    elsif location =~ %r{^id:\d+$}
      u = '&id=%S'
    elsif location =~ %r{^\w+}
      u = '&q="%S"'
    else
      return nil
    end
    @@w_url + u
  end
end
