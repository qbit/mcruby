# utilities for various tasks
class Utils
  def plugins_dir
    __dir__
  end

  def load_plugins(plugs)
    Dir[plugins_dir + '/../plugins/*'].each do |plugin|
      name = File.basename(plugin, '.rb')
      next if name == 'plugins'
      puts "Loading #{name}"
      load(plugin)
      next unless plugs[name].nil?
      # Since plugins can implement any class name, we force the requirement
      # that the file name will be the class name.
      plugs[name] = Object.const_get(name).new
    end
  end
end
