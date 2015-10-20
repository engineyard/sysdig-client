class Sysdig::GetNotification < Sysdig::Request
  def real(notification_id)
    service.request(
      :path => "/api/notifications/#{notification_id}",
    )
  end
end
