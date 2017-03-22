RSpec.describe "diverging a conversation" do
  include Dialogue::Test::ConversationHelpers
  include Dialogue::Test::SlackClientStubbing

  let(:message) { double(:message, user: "U1234", channel: "C1234", team: "T1234") }

  before { stub_slack_chat true }
  after { Dialogue.clear_templates }

  describe "diverging from a simple conversation to a simple conversation" do
    it "unregisters the conversation when it's complete" do
      Dialogue::ConversationTemplate.build(:first_step) do |convo|
        convo.say "First step"
      end.register

      Dialogue::ConversationTemplate.build(:second_step) do |convo|
        convo.diverge :first_step
        convo.say "Second step"
      end.register.start message

      expect(Dialogue.conversations).to be_empty
      expect(stubbed_conversations.count).to eq 2
      expect(stubbed_conversations.first).to eq "First step"
      expect(stubbed_conversations.second).to eq "Second step"
    end

    it "runs the first step of the diverged conversation" do
      Dialogue::ConversationTemplate.build(:ask_color) do |convo|
        convo.ask "What color t-shirt do you want?" do |convo, response|
          convo.end "Thank you!"
        end
      end.register

      Dialogue::ConversationTemplate.build(:retrieve_shirt_specs) do |convo|
        convo.ask "What size t-shirt do you want?" do |convo, response|
          convo.diverge :ask_color
        end
      end.register.start message

      answer_all_questions "XL", "black"

      expect(Dialogue.conversations).to be_empty
      expect(stubbed_conversations.count).to eq 3
      expect(stubbed_conversations.first).to eq "What size t-shirt do you want?"
      expect(stubbed_conversations.second).to eq "What color t-shirt do you want?"
      expect(stubbed_conversations.third).to eq "Thank you!"
    end
  end

  describe "diverging at the end from a simple conversation" do
    it "unregisters the conversation when it's complete" do
      Dialogue::ConversationTemplate.build(:second_step) do |convo|
        convo.say "Second step"
      end.register

      Dialogue::ConversationTemplate.build(:first_step) do |convo|
        convo.say "First step"
        convo.diverge :second_step
      end.register.start message

      expect(Dialogue.conversations).to be_empty
      expect(stubbed_conversations.count).to eq 2
      expect(stubbed_conversations.first).to eq "First step"
      expect(stubbed_conversations.second).to eq "Second step"
    end
  end

  describe "returning from a diverged conversation" do
    it "runs the conversation after the diverge" do
      Dialogue::ConversationTemplate.build(:ask_color) do |convo|
        convo.ask "What color t-shirt do you want?"
      end.register

      Dialogue::ConversationTemplate.build(:retrieve_shirt_specs) do |convo|
        convo.ask "What size t-shirt do you want?" do |convo, response|
          convo.diverge :ask_color
          convo.say "Thank you!"
          convo.end
        end
      end.register.start message

      answer_all_questions "XL", "black"

      expect(Dialogue.conversations).to be_empty
      expect(stubbed_conversations.count).to eq 3
      expect(stubbed_conversations.first).to eq "What size t-shirt do you want?"
      expect(stubbed_conversations.second).to eq "What color t-shirt do you want?"
      expect(stubbed_conversations.third).to eq "Thank you!"
    end
  end

  describe "diverging to simple step and then returning" do
    it "runs the conversation after the diverge" do
      Dialogue::ConversationTemplate.build(:ready_statement) do |convo|
        convo.say "We are ready!"
      end.register

      Dialogue::ConversationTemplate.build(:retrieve_shirt_size) do |convo|
        convo.diverge :ready_statement
        convo.ask "What size t-shirt do you want?" do |convo, response|
          convo.ask "What color t-shirt do you want?"
        end
      end.register.start message

      answer_all_questions "XL", "black"

      expect(Dialogue.conversations).to be_empty
      expect(stubbed_conversations.count).to eq 3
    end
  end
end
