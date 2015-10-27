require 'sysdig_helper'

RSpec.describe Sysdig::UserNotifications do
  let!(:client) { create_client }

  it "lists user notifications" do
    default_notifications = client.user_notifications

    expect(default_notifications.email_enabled).to      eq(false)
    expect(default_notifications.sns_enabled).to        eq(false)
    expect(default_notifications.pager_duty_enabled).to eq(false)

    expect(default_notifications.email_recipients).to eq([])

    expect(default_notifications.sns_topics).to eq([])

    expect(default_notifications.pager_duty_integrated).to eq(false)
    expect(default_notifications.pager_duty_bind_resolution).to eq(false)
    expect(default_notifications.pager_duty_connect_url).to match("connect.pagerduty.com")
  end

  it "updates sns topics" do
    uns = client.user_notifications
    uns.sns_topics << (topic = SecureRandom.uuid)

    expect {
      uns.save
    }.to change {
      client.user_notifications.reload.sns_topics
    }.from([]).to(containing_exactly(topic))

    expect(uns.sns_topics).to containing_exactly(topic)
  end
end
