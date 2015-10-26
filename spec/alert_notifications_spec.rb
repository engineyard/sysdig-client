require 'sysdig_helper'

RSpec.describe Sysdig::AlertNotifications do
  let!(:client) { create_client }

  it "lists alert notifications" do
    expect(client.alert_notifications).to be_empty
  end

  context "with an alert notification", :mock_only do
    let!(:alert) { create_alert(client: client, alert: {timespan: 60_000_000}) }
    let!(:alert_notification) { client.create_alert_notification(alert) }

    it "lists alert notifications" do
      expect(client.alert_notifications.all).to contain_exactly(alert_notification)
    end

    it "updates an alert notification" do
      expect {
        alert_notification.resolve!
      }.to change {
        client.alert_notifications.get(alert_notification.identity).resolved
      }.from(false).to(true)
    end
  end
end
