class Sysdig::PagerDutyNotification < Sysdig::UserNotification

  type :pagerDuty

  attribute :enabled,         type:  :boolean
  attribute :integrated,      type:  :boolean
  attribute :bind_resolution, type:  :boolean, alias: "resolveOnOk"
  attribute :connect_url,     alias: "connectUrl"

  def save
    notification = service.update_user_notifications("pagerDuty" => {
      "enabled"     => self.enabled,
      "integrated"  => self.integrated,
      "resolveOnOk" => self.bind_resolution,
      "connectUrl"  => self.connect_url,
    }).body.fetch("userNotification")

    merge_attributes(notification.fetch("pagerDuty"))
  end
end
