RSpec.describe Converse::MessageDecorators::Slack do
  let(:channel_id) { "CHANNEL1" }
  let(:message) { double(:message, user: user_id, channel: channel_id, team: team_id) }
  let(:team_id) { "TEAM1" }
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

  describe "#team_id" do
    it "returns the team from the original message" do
      expect(subject.team_id).to eq team_id
    end

    it "returns the source team from the original message if the team is not present" do
      allow(message).to receive_messages(team: nil, source_team: team_id)

      expect(subject.team_id).to eq team_id
    end
  end

  describe "#user_id" do
    it "returns the user from the original message" do
      expect(subject.user_id).to eq user_id
    end
  end

  describe "delegating" do
    it "delegates any other messages to the original message" do
      allow(message).to receive(:text).and_return "Text"

      expect(subject.text).to eq "Text"
    end
  end
end
