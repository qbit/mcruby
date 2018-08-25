require './plugins/plugins.rb'

# FRIDAY?!
class TGIF < Plugin
  @@friday = <<EOF
 _____ ____  ___ ____    _ __   ___
|  ___|  _ \|_ _|  _ \  / \\ \ / / |
| |_  | |_) || || | | |/ _ \\ V /| |
|  _| |  _ < | || |_| / ___ \| | |_|
|_|   |_| \_\___|____/_/   \_\_| (_)
EOF
  def response(_to, _from, msg)
    time = Time.now
    return @@friday if time.wday == 5 && msg =~ %r{tgif}i
    return ':(' if time.wday != 5 && msg =~ %r{tgif}i
  end

  def test
    true
  end
end
