# encoding: utf-8
module UniParser

  class Page
    attr_accessor :result

    def self.field(name, &block)
      if block_given?
        attr_writer name.to_sym
        send :define_method, name.to_sym do
          unless instance_variable_defined?("@#{name}")
            value = instance_eval(&block)
            value = clean_up(value) if value.is_a?(String)
            instance_variable_set("@#{name}", value)
          end
          instance_variable_get("@#{name}")
        end
      else
        attr_accessor name.to_sym
      end
    end

    # @param [Object] options
    # @option options [String] :source Сырой HTML в виде строки
    # @option options [String] :url Урла
    def initialize(options = {})
      @source = options.delete(:source)
      @url = options.delete(:url)
    end

    def agent
      options = {
        proxy: @proxy
      }

      @agent ||= UniParser::Agent.new options
    end

    def source
      @source ||= agent.get(@url) || throw('Define source or url... =(')
    rescue Exception => e
      raise ConnectionError, "#{e.to_s}, #{agent.history.inspect}", e.backtrace
    end

    def json
      return source if source.is_a?(Hash)
      @json ||= MultiJson.decode source if source
    rescue Exception => e
      raise DecodeError, "#{e.to_s}, #{agent.history.inspect}", e.backtrace
    end

    def root
      @root ||= Nokogiri::HTML(source, 'utf-8')
    end

    def file(file_url)
      agent.get_file file_url
    end

    def clean_up(str)
      str.strip.sub(/^\.{3}/, '').sub(/\,$/, '').gsub("\u00A0", "\u0020").strip
    end

    def format_date(str)
      ['января', 'февраля', 'марта', 'апреля',
      'мая', 'июня', 'июля', 'августа', 'сентября',
      'октября', 'ноября', 'декабря'].each_with_index { |month, i| str = str.sub(month, (i + 1).to_s) }
      str.strip.gsub(/[^\d]+/, '-')
    end

  end
end
