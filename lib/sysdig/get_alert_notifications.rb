class Sysdig::GetAlertNotifications < Sysdig::Request
  def real(from, to)
    from_i, to_i = timestamps(from, to)

    service.request(
      :path   => "/api/notifications",
      :params => {"from" => from_i, "to" => to_i},
    )
  end

  def timestamps(*args)
    args.map { |a| a.to_i * 1_000_000 }
  end

  def mock(from, to)
    from_i, to_i = timestamps(from, to)

    notifications = service.data[:alert_notifications].values.select { |an|
      an["timestamp"] >= from_i && an["timestamp"] <= to_i
    }

    service.response(
      :body => { "notifications" => notifications },
    )
  end
end
