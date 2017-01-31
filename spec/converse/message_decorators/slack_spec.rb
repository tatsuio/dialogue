RSpec.describe Converse::MessageDecorators::Slack do
  let(:channel_id) { "CHANNEL1" }
  let(:message) { double(:message, user: user_id, channel: channel_id) }
  let(:user_id) { "USER1" }
  subject { described_class.new(message) }

  describe "#initialize" do
    it "is initialized with a message" do
      expect(described_class.new(message).original_message).to eq message
    end
  end

  describe "#channel_id" do
    it "returns the channel from the original message" do
      expect(subject.channel_id).to eq channel_id
    end
  end

  describe "#user_id" do
    it "returns the user from the original message" do
      expect(subject.user_id).to eq user_id
    end
  end
end
