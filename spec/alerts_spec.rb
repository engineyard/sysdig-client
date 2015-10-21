require 'sysdig_helper'

RSpec.describe Sysdig::Alerts do
  let!(:client) { create_client }

  it "lists alerts" do
    expect(client.alerts).to be_empty
  end

  context "with some alerts" do
    let!(:alert1) { create_alert(client: client) }
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
  end
end
