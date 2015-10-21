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

  it "updates sns topics" do
    sns = client.user_notifications.get(:sns)
    topic = SecureRandom.uuid

    expect {
      sns.topics << topic
      sns.save
    }.to change {
      client.user_notifications.get(:sns).topics
    }.from([]).to(containing_exactly(topic)).
    and change { sns.topics }.from([]).to(containing_exactly(topic))
  end
end
