class Sysdig::UserNotifications < Sysdig::Singular

  attribute :sns_enabled, type: :boolean, squash: ["sns", "enabled"]
  attribute :sns_topics,  type: :array, squash: ["sns", "topics"]

  attribute :email_enabled,    type: :boolean, squash: ["email", "enabled"]
  attribute :email_recipients, type: :array, squash: ["email", "recipients"]

  attribute :pager_duty_enabled,         type: :boolean, squash: ["pagerDuty", "enabled"]
  attribute :pager_duty_integrated,      type: :boolean, squash: ["pagerDuty", "integrated"]
  attribute :pager_duty_bind_resolution, type: :boolean, squash: ["pagerDuty", "resolveOnOk"]
  attribute :pager_duty_connect_url,     squash: ["pagerDuty", "connectUrl"]

  def fetch_attributes(options={})
    service.get_user_notifications.body.fetch("userNotification")
  end

  def save
    data = service.update_user_notifications(
      "sns" => {
        "enabled" => self.sns_enabled,
        "topics"  => self.sns_topics,
      },
      "email" => {
        "enabled"    => self.email_enabled,
        "recipients" => self.email_recipients,
      },
      "pagerDuty" => {
        "enabled"     => self.pager_duty_enabled,
        "integrated"  => self.pager_duty_integrated,
        "resolveOnOk" => self.pager_duty_bind_resolution,
        "connectUrl"  => self.pager_duty_connect_url,
      },
    ).body.fetch("userNotification")

    merge_attributes(data)
  end
end
