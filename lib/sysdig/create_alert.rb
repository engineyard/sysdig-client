class Sysdig::CreateAlert < Sysdig::Request
  def self.params
    %w[condition createdOn description enabled filter modifiedOn name notify segmentBy segmentCondition severity timespan type version]
  end

  def self.slice(alert)
    Cistern::Hash.slice(Cistern::Hash.stringify_keys(alert), *self.params)
  end

  def real(alert)
    service.request(
      :method => :post,
      :path   => "/api/alerts",
      :body   => { "alert" => self.class.slice(alert) },
    )
  end

  def mock(alert)
    alert_id = service.serial_id
    body = self.class.slice(alert).merge!("id" => alert_id)

    service.data[:alerts][alert_id] = body

    service.response(
      :status => 201,
      :body   => {"alert" => body},
    )
  end
end
