RSpec.describe Converse::Streams::Slack do
  describe "#initialize" do
    it "optionally takes an access token" do
      expect(Slack::Web::Client).to \
        receive(:new).with(token: "TOKEN").and_call_original

      described_class.new("TOKEN")
    end
  end

  describe "#puts" do
    let(:channel_id) { "C12345" }
    let(:statement) { "Hello" }
    let(:user_id) { "U12345" }

    it "posts the message to slack to the user and channel" do
      expect_any_instance_of(Slack::Web::Client).to \
        receive(:chat_postMessage).with(channel: channel_id, as_user: true,
                                        text: statement)

        subject.puts statement, channel_id, user_id
    end

    it "can post the message as a direct mention" do
      expect_any_instance_of(Slack::Web::Client).to \
        receive(:chat_postMessage).with(channel: channel_id, as_user: true,
                                        text: "<@#{user_id}> #{statement}")

      subject.puts statement, channel_id, user_id, { direct_mention: true }
    end
  end
end
