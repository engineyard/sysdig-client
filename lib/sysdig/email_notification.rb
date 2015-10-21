class Sysdig::EmailNotification < Sysdig::UserNotification

  type :email

  attribute :recipients, type: :array

  def save
    notification = service.update_user_notifications("email" => {
      "enabled"    => self.enabled,
      "recipients" => self.receipents,
    }).body.fetch("userNotification")

    merge_attributes(notification.fetch("email"))
  end
end
