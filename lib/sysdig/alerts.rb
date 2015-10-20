class Sysdig::Alerts < Sysdig::Collection

  model Sysdig::Alert

  def all(params={})
    load(service.get_alerts.body.fetch("alerts"))
  end

  def get(identity)
    new(service.get_alert(identity).body.fetch("alert"))
  end
end
