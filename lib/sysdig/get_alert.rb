class Sysdig::GetAlert < Sysdig::Request
  def real(alert_id)
    service.request(
      :method => :get,
      :path   => File.join("/api/alerts", alert_id.to_s),
    )
  end

  def mock(alert_id)
    service.response(
      :body => { "alert" => service.data[:alerts].fetch(alert_id.to_i) },
    )
  end
end
