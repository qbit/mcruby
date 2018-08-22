require 'pledge'
require 'openssl'
require 'socket'

require './lib/utils.rb'

Pledge.pledge('rpath inet')

plugins = {}
util = Utils.new
server = TCPServer.new(3232)
ctx = OpenSSL::SSL::SSLContext.new

ctx.cert = OpenSSL::X509::Certificate.new(File.open('cert.pem'))
ctx.key = OpenSSL::PKey::RSA.new(File.open('key.pem'))

ssl_server = OpenSSL::SSL::SSLServer.new(server, ctx)

util.load_plugins(plugins)

loop do
  conn = ssl_server.accept
  Thread.new do
    begin
      while (line = conn.gets)
        line = line.chomp
        plugins.each do |p|
          begin
            conn.puts p[1].response('nobody', 'nobody', line)
          rescue StandardError
            warn $ERROR_INFO
          end
        end
      end
    rescue StandardError
      warn $ERROR_INFO
      util.load_plugins(plugins)
    end
  end
end
