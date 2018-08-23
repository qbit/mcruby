require './plugins/plugins.rb'
require 'cgi'
require 'nokogiri'
require 'open-uri'

# Looks up beer via beeradvocate
class Beer < Plugin
  def response(_to, _from, msg)
    return unless msg =~ %r{^beer:}
    msg.gsub! 'beer: ', ''
    beer(msg)
  end

  def test
    beer = response('test', 'test', 'beer: modus hoperandi')
    abort("invalid data for 'modus hoperandi': #{beer[:abv]}") unless
      beer[:abv] == '6.80%'
    true
  end

  def beer(beer)
    beer_page(beer_url(beer))
  end

  private

  @@ba_url = 'https://beeradvocate.com'

  def get_page(url)
    uri = URI.parse(url)
    Nokogiri.HTML(uri.open)
  end

  def get_search_page(name)
    get_page(@@ba_url + '/search/?qt=beer&q=' +
             CGI.escape(name))
  end

  def profile(page)
    page.css('ul li a').map do |tag|
      return tag.attributes['href'].text if
        tag &&
        tag.attributes['href'] &&
        tag.attributes['href'].text
           .match(%r{^/beer/profile})
    end
  end

  def get_tag_text(table, regex)
    table.css('a').select do |tag|
      return tag.text if
        tag &&
        tag.attributes['href'] &&
        tag.attributes['href'].value
           .match(regex)
    end
  end

  def beer_url(name)
    page = get_search_page(name.to_s)
    href = profile(page)
    @@ba_url + '/' + href
  end

  def beer_page(url)
    page = get_page(url)
    table = page.css('#info_box')
    b_name = page.css('div.titleBar h1')[0].children[0].text
    b_score = page.css('.ba-ravg').text
    b_style = get_tag_text(table, %r{^/beer/style/\d+/?$})
    b_brewery = get_tag_text(table, %r{^/beer/profile/\d+/?$})
    b_abv = table.to_s.match(%r{(\d+\.\d+\%)})[1]

    {
      name: b_name,
      score: b_score,
      style: b_style,
      abv: b_abv,
      brewery: b_brewery
    }
  end
end
