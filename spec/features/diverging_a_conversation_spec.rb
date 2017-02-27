RSpec.describe "diverging a conversation" do
  include Converse::Test::ConversationHelpers
  include Converse::Test::SlackClientStubbing

  let(:message) { double(:message, user: "U1234", channel: "C1234", team: "T1234") }

  before { stub_slack_chat true }
  after { Converse.clear_templates }

  describe "diverging from a simple conversation to a simple conversation" do
    it "runs the first step of the diverged conversation" do
      Converse::ConversationTemplate.build(:ask_color) do |convo|
        convo.ask "What color t-shirt do you want?" do |convo, response|
          convo.end "Thank you!"
        end
      end.register

      Converse::ConversationTemplate.build(:retrieve_shirt_specs) do |convo|
        convo.ask "What size t-shirt do you want?" do |convo, response|
          convo.diverge :ask_color
        end
      end.register.start message

      answer_all_questions "XL", "black"

      expect(stubbed_conversations.count).to eq 3
      expect(stubbed_conversations.first).to eq "What size t-shirt do you want?"
      expect(stubbed_conversations.second).to eq "What color t-shirt do you want?"
      expect(stubbed_conversations.third).to eq "Thank you!"
    end
  end

  describe "returning from a diverged conversation" do
    it "runs the conversation after the diverge" do
      Converse::ConversationTemplate.build(:ask_color) do |convo|
        convo.ask "What color t-shirt do you want?"
      end.register

      Converse::ConversationTemplate.build(:retrieve_shirt_specs) do |convo|
        convo.ask "What size t-shirt do you want?" do |convo, response|
          convo.diverge :ask_color
          convo.say "Thank you!"
          convo.end
        end
      end.register.start message

      answer_all_questions "XL", "black"

      expect(stubbed_conversations.count).to eq 3
      expect(stubbed_conversations.first).to eq "What size t-shirt do you want?"
      expect(stubbed_conversations.second).to eq "What color t-shirt do you want?"
      expect(stubbed_conversations.third).to eq "Thank you!"
    end
  end
end
