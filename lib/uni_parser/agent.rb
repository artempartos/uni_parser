module UniParser
  class Agent
    include RoundRobin

    AGENT_ALIASES = ['Mac Safari', 'Mac Firefox', 'Linux Firefox', 'Linux Mozilla',
      'Windows IE 8', 'Windows IE 9', 'Windows Mozilla']

      attr_reader :current_proxy, :options

      def initialize(options = {})
        @agent = Mechanize.new { |agent|
          agent.open_timeout = UniParser.config.open_timeout if UniParser.config.open_timeout
          agent.read_timeout = UniParser.config.read_timeout if UniParser.config.read_timeout
        }
        @options = options
        @proxy = Proxy.new(options[:proxy]) if options[:proxy]
      end

      def history
        @agent.history
      end

      def get(url, parameters = [], referer = nil, headers = {})
        @agent.reset
        @agent.follow_redirect = false

        set_proxy
        set_user_agent

        begin
          @page = @agent.get(url, [], referer)
          raise if @page.code == '302'
        rescue => e
          p e
          freeze_current_proxy
          raise e
        end

        @page.body
      end

      def get_file(url)
        begin
          file = @agent.get url
        rescue => e
          freeze_current_proxy
          raise e
        end

        ext = file.filename.split('.').last
        if file.body_io.instance_of?(Tempfile)
          body = StringIO.new(file.body_io.read)
          create_temp(file.filename, body, ext)
        else
          create_temp(file.filename, file.body_io, ext)
        end
      end

      def create_temp(name, body, ext)
        temp_file = Tempfile.new([name, ".#{ext}"])
        temp_file.binmode
        temp_file.write body.string
        temp_file.flush
        temp_file
      end

      def set_proxy
        return if @options[:proxy] === false

        return unless @proxy || UniParser.config.use_proxy?

        @current_proxy = @proxy || UniParser.config.proxy_list.next
        @agent.set_proxy current_proxy.host, current_proxy.port
      end

      def set_user_agent
        @agent.user_agent_alias = next! AGENT_ALIASES
      end

      private

      def freeze_current_proxy
        UniParser.config.proxy_list.freeze_proxy current_proxy
      end

    end
  end
