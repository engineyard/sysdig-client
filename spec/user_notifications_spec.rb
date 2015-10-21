require 'sysdig_helper'

RSpec.describe Sysdig::UserNotifications do
  let!(:client) { create_client }

  it "lists user notifications" do
    expect(client.user_notifications.to_a).to contain_exactly(
      Sysdig::EmailNotification.new(enabled: false, recipients: []),
      Sysdig::PagerDutyNotification.new(enabled: false, integrated: false, bind_resolution: false, connect_url: a_string_matching("connect.pagerduty.com")),
      Sysdig::SnsNotification.new(enabled: false, topics: []),
    )
  end

  it "fetches a specific user notification" do
    expect(client.user_notifications.get(:sns)).to eq(
      Sysdig::SnsNotification.new(enabled: false, topics: [])
    )
  end
end
