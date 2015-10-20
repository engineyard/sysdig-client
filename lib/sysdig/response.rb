class Sysdig::Response
  class Error < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
      super(
        {
          :body    => response.body,
          :headers => response.headers,
          :request => response.request,
          :status  => response.status,
        }.inspect
      )
    end

    def errors
      response.body["errors"]
    end

    def full_messages
      if errors.is_a?(Hash)
        errors.inject([]){|r,(k,v)| r += v.map{|s| "#{k.capitalize} #{s}"}}
      else # Array or String
        errors
      end
    end
  end

  BadRequest    = Class.new(Error)
  NotFound      = Class.new(Error)
  Unprocessable = Class.new(Error)
  Conflict      = Class.new(Error)
  Unexpected    = Class.new(Error)

  EXCEPTION_MAPPING = {
    400 => BadRequest,
    404 => NotFound,
    409 => Conflict,
    422 => Unprocessable,
    500 => Unexpected,
  }

  attr_reader :headers, :status, :body, :request

  def initialize(options={})
    @status  = options[:status]
    @headers = options[:headers]
    @body    = options[:body]
    @request = options[:request]
  end

  def successful?
    self.status >= 200 && self.status <= 299 || self.status == 304
  end

  def raise!
    if !successful?
      raise((EXCEPTION_MAPPING[self.status] || Error).new(self))
    else self
    end
  end
end
