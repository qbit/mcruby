load 'lib/utils.rb'

plugins = {}
util = Utils.new

util.load_plugins(plugins)

plugins.each do |p|
  if p[1].test
    puts "pass #{p[0]}"
  else
    abort "FAIL #{p[0]}!"
  end
end
