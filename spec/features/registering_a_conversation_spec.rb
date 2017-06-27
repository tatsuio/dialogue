RSpec.describe "registering a conversation" do
  include Dialogue::Test::SlackClientStubbing

  let(:message) { double(:message, user: "U1234", channel: "C1234",
                         team: "T1234") }

  before { stub_slack_chat true }
  after { Dialogue.clear_templates }

  describe "registering a conversation with data" do
    it "adds the data to the conversation" do
      Dialogue::ConversationTemplate.build(:template) do |convo|
        convo.ask "How are you?"
      end.register.start message, { data: { parameter1: "value1" } }

      expect(Dialogue.conversations.count).to eq 1
      expect(Dialogue.conversations.first.fetch(:parameter1)).to eq "value1"
    end
  end
end
