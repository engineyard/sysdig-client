class Sysdig::GetAlerts < Sysdig::Request
  def real(from: nil, to: nil)
    params = {}

    if from
      params.merge!(from.to_i * 1_000_000)
    end

    if to
      params.merge!(to.to_i * 1_000_000)
    end

    service.request(
      :method => :get,
      :path   => "/api/alerts",
      :params => params,
    )
  end

  def mock(from: nil, to: nil)
    alerts = service.data[:alerts].values

    service.response(
      :body => { "alerts" => alerts },
    )
  end
end
