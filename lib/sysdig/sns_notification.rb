class Sysdig::SnsNotification < Sysdig::UserNotification

  type :sns

  attribute :topics, type: :array

  def save
    notification = service.update_user_notifications(self.identity => {
      "enabled" => self.enabled,
      "topics"  => self.topics,
    }).body.fetch("userNotification")

    merge_attributes(notification.fetch(self.identity))
  end
end
