require 'sysdig_helper'

RSpec.describe Sysdig::Alerts do
  let!(:client) { create_client }

  it "lists alerts" do
    expect(client.alerts).to be_empty
  end

  context "with some alerts" do
    let!(:alert1) { create_alert(client: client, alert: {timespan: 60_000_000}) }
    let!(:alert2) { create_alert(client: client) }

    it "lists alerts" do
      expect(client.alerts).to contain_exactly(alert1, alert2)
    end

    it "destroys an alert" do
      expect {
        alert1.destroy
      }.to change { client.alerts.all }.from(
        containing_exactly(alert1, alert2)
      ).to(
        containing_exactly(alert2)
      )
    end

    it "calms down microsecond timespans" do
      expect(alert1.timespan).to eq(60)
    end

    it "parses nil filter" do
      alert1.filter = nil
      expect(alert1.filter).to eq(nil)

      alert1.filter = []
      expect(alert1.filter).to eq(nil)

      tag = SecureRandom.uuid
      alert1.filter = "agent.tag.id = \"#{tag}\""
      expect(alert1.filter).to eq("agent.tag.id" => tag)
    end
  end
end
