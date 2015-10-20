class Sysdig::GetAlert < Sysdig::Request
  def real(alert_id)
    service.request(
      :method => :get,
      :path   => File.join("/api/alerts", alert_id.to_s),
    )
  end
end
