RSpec.describe Dialogue::ConversationTemplateRunner do
  let(:author_id) { "BOT" }
  let(:channel_id) { "CHANNEL1" }
  let(:message) { double(:message, user: user_id, channel: channel_id, team: team_id) }
  let(:options) {{ author_id: author_id }}
  let(:template) { double(:conversation_template, template: Proc.new {}) }
  let(:team_id) { "TEAM1" }
  let(:user_id) { "USER1" }
  subject { described_class.new message, options }

  describe "#initialize" do
    it "initializes with a message and options" do
      expect(subject.message).to eq message
      expect(subject.options).to eq options
    end
  end

  describe "#decorated_message" do
    it "decorates the message to make the interface consistant" do
      expect(subject.decorated_message.user_id).to eq user_id
    end
  end

  describe "#run" do
    context "with a non-registered conversation" do
      after { Dialogue.conversations.clear }

      it "it creates a conversation" do
        expect(Dialogue::Conversation).to \
          receive(:new).with(template, Dialogue::MessageDecorators::Slack, options)
          .and_call_original

        subject.run template
      end

      it "adds the conversation to the factory" do
        expect(Dialogue).to receive(:register_conversation)

        subject.run template
      end

      it "performs the conversation" do
        expect_any_instance_of(Dialogue::Conversation).to receive(:perform)

        subject.run template
      end
    end

    context "with a registered conversation" do
      let(:conversation) { Dialogue::Conversation.new template, decorated_message, options }
      let(:decorated_message) { Dialogue::MessageDecorators::Slack.new(message) }

      before do
        Dialogue.register_conversation conversation
      end
      after { Dialogue.conversations.clear }

      it "does not add the conversation to the factory" do
        expect(Dialogue).to_not receive(:register_conversation)

        subject.run template
      end

      it "it continutes the conversation" do
        expect(conversation).to receive(:perform)

        subject.run template
      end
    end

    context "with a message from the author" do
      before { allow(message).to receive(:user).and_return author_id }

      it "does not create the conversation" do
        expect(Dialogue::Conversation).to_not receive(:new)

        subject.run template
      end
    end
  end
end
