class Sysdig::CreateAlert < Sysdig::Request
  def self.params
    %w[name description enabled filter type condition timespan severity notify segmentBy segmentCondition groupCondition groupBy groupAggregations]
  end

  def real(alert)
    service.request(
      :method => :post,
      :path   => "/api/alerts",
      :body   => { "alert" => alert },
    )
  end

  def mock(alert)
    alert_id = service.serial_id
    body     = Cistern::Hash.slice(Cistern::Hash.stringify_keys(alert), *self.class.params)

    service.data[:alerts][alert_id] = body.merge!("id" => alert_id)

    service.response(
      :status => 201,
      :body   => {"alert" => body},
    )
  end
end
