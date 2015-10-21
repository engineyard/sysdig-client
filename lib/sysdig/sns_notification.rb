class Sysdig::SnsNotification < Sysdig::UserNotification

  type :sns

  attribute :topics, type: :array

  def save
    notification = service.update_user_notifications("sns" => {
      "enabled" => self.enabled,
      "topics"  => self.topics,
    }).body.fetch("userNotification")

    merge_attributes(notification.fetch("sns"))
  end
end
