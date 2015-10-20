class Sysdig::Mock
  def self.data
    @@data ||= Hash.new { |h,url|
      h[url] = {
        :alerts => {},
      }
    }
  end

  attr_reader :url, :logger

  def initialize(options={})
    @url     = options[:url]    || "https://langley.engineyard.com"
    @logger  = options[:logger] || Logger.new(nil)
  end

  def url_for(*pieces)
    File.join(self.url, *pieces)
  end

  def response(options={})
    status  = options[:status] || 200
    body    = options[:body]
    headers = {
      "Content-Type"  => "application/json; charset=utf-8"
    }.merge(options[:headers] || {})

    logger.debug "MOCKED RESPONSE: #{status}"
    logger.debug('response') { headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n") }
    logger.debug caller[0]
    logger.debug('response.body') { body }

    Sysdig::Response.new(
      :status  => status,
      :headers => headers,
      :body    => body,
      :request => {
        :method  => :mocked,
        :url     => caller[1],
      }
    ).raise!
  end

  def data
    self.class.data[self.url]
  end
end
