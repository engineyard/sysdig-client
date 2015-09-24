class Sysdig::Client::Alerts < Sysdig::Client::Collection

  model Sysdig::Client::Alert

  def all(params={})
    load(service.get_alerts.body.fetch("alerts"))
  end
end
