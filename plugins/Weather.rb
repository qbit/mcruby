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
    abort("Invalid weather data: #{w}") if w !~ %r{^Pueblo}
    true
  end

  def pretty(wth)
    descrs = []
    d_c = (wth['main']['temp'] - 273.15).round(2)
    d_f = (d_c * 1.800 + 32.00).round(2)
    h = wth['main']['humidity']

    wth['weather'].each do |d|
      descrs.push d['description']
    end

    descrs = descrs.join ', '
    url = "https://openweathermap.org/city/#{wth['id']}"
    "#{wth['name']}: #{d_f} °F (#{d_c} °C), Humidity: #{h}, #{descrs}, #{url}"
  end

  def weather(from, location)
    url = loc_to_url(location)
    @@redis.set(from + '_weather', location) unless url.nil?
    url.gsub! '%S', CGI.escape(location)
    url.gsub! '%T', @@token
    uri = URI.parse(url)
    pretty JSON.parse(uri.open.read)
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
