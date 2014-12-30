module UniParser
  class Proxy
    attr_reader :host, :port

    def initialize(url)
      uri = URI url
      @host, @port = uri.host, uri.port
    end

    def freeze
      @frozen_to = Time.now + freeze_time
    end

    def freeze_time
      UniParser.config.proxy_freeze_time || 1.minute
    end

    def frozen?
      Time.now < @frozen_to
    end
  end
end
