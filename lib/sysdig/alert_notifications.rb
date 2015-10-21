class Sysdig::AlertNotifications < Sysdig::Collection

  model Sysdig::AlertNotification

  def all(options={})
    to   = options[:to]   || Time.now
    from = options[:from] || Time.at(Time.now.to_i - 86400) # 1 day

    load(service.get_notifications(from, to).body.fetch("notifications"))
  end
end
