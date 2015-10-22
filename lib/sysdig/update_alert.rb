class Sysdig::UpdateAlert < Sysdig::Request
  # @note alert[version] might mean lock version which should be fun
  def real(alert_id, alert)
    service.request(
      :method => :put,
      :path   => File.join("/api/alerts", alert_id.to_s),
      :body   => { "alert" => Sysdig::CreateAlert.slice(alert) },
    )
  end

  def mock(alert_id, alert)
    body = service.data[:alerts].fetch(alert_id.to_i)

    body.merge!(Sysdig::CreateAlert.slice(alert))

    service.response(
      :body => {"alert" => body},
    )
  end
end
