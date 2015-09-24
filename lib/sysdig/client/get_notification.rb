class Sysdig::Client::GetNotification < Sysdig::Client::Request
  def real(notification_id)
    service.request(
      :path => "/api/notifications/#{notification_id}",
    )
  end
end
