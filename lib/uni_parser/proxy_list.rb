module UniParser
  class ProxyList
    include Enumerable
    include RoundRobin

    attr_reader :frozen_proxies
    attr_reader :proxies

    def initialize(proxies = [])
      @proxies = proxies
      @frozen_proxies = []
    end

    def each(&block)
      @proxies.each(&block)
    end

    def <<(proxy)
      @proxies << proxy
    end

    def next
      unfreeze_proxies
      next! @proxies
    end

    def freeze_proxy(proxy)
      return unless proxy
      @proxies.delete proxy
      proxy.freeze
      @frozen_proxies << proxy unless proxy.in?(@frozen_proxies)
    end

    def unfreeze_proxies
      @frozen_proxies.each do |proxy|
        return if proxy.frozen?
        @frozen_proxies.delete proxy
        @proxies << proxy
      end
    end
  end
end
