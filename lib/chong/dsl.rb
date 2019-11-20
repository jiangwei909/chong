lambda {
  hosts = []

  Kernel.send :define_method, :get do |url, options={}, &block|
    hosts << {:url=>url, :options=> options, :handle=>block}
  end

  Kernel.send :define_method, :each_host do |&block|
    hosts.each do |host|
      block.call host
    end
  end

}.call
