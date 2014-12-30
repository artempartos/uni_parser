module UniParser
  class Config
    attr_accessor :proxy_list, :proxy_freeze_time, :read_timeout, :open_timeout

    def proxy_list=(url_list)
      @proxy_list = UniParser::ProxyList.new

      url_list.each do |url|
        proxy = Proxy.new url
        @proxy_list << proxy
      end
    end

    def use_proxy?
      proxy_list && proxy_list.any?
    end

  end
end
