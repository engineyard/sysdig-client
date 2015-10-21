class Sysdig::Mock
  def self.reset!
    super

    @id = 0
  end

  def self.data
    @@data ||= Hash.new { |h,url|
      h[url] = {
        :alerts => {},
        :user_notifications => {
          "email" => {
            "enabled"    => false,
            "recipients" => []
          },
          "sns" => {
            "enabled" => false,
            "topics"  => []
          },
          "pagerDuty" => {
            "enabled"     => false,
            "integrated"  => false,
            "resolveOnOk" => false,
            "connectUrl"  => "https://connect.pagerduty.com/connect?vendor=x&callback=https://app.sysdigcloud.com/api/pagerDuty/callback/y/z"
          }
        }
      }
    }
  end

  attr_reader :url, :logger, :account_id

  def initialize(options={})
    @url     = options[:url]    || "https://langley.engineyard.com"
    @logger  = options[:logger] || Logger.new(nil)

    username, password, token = *options.values_at(:username, :password, :token)

    @account_id = (username && password) ? Digest::SHA256.hexdigest("#{username}:#{password}") : token
  end

  def url_for(*pieces)
    File.join(self.url, *pieces)
  end

  def response(options={})
    status  = options[:status] || 200
    body    = options[:body]
    headers = {
      "Content-Type" => "application/json; charset=utf-8",
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
    self.class.data[self.account_id]
  end

  def serial_id
    @id ||= 0
    @id += 1
  end
end
