RSpec.describe Converse do
  describe ".build" do
    it "runs the DSL with the specified block" do
      block = Proc.new {}

      expect(Converse::DSL).to receive(:run).with(block)

      described_class.build &block
    end
  end

  describe ".clear_conversations" do
    let(:conversation) { double(:conversation, user_id: "USER1", channel_id: "CHANNEL1") }

    it "removes all the conversations from memory" do
      described_class.register_conversation conversation

      described_class.clear_conversations

      expect(described_class.conversations).to be_empty
    end
  end

  describe ".conversation_registered?" do
    it "delegates to the conversation factory" do
      expect(Converse::ConversationFactory.instance).to receive(:registered?).with "USER1", "CHANNEL1"

      described_class.conversation_registered? "USER1", "CHANNEL1"
    end
  end

  describe ".conversations" do
    it "delegates to the conversation factory" do
      expect(Converse::ConversationFactory.instance).to receive(:conversations)

      described_class.conversations
    end
  end

  describe ".find_conversation" do
    it "delegates to the conversation factory" do
      expect(Converse::ConversationFactory.instance).to receive(:find).with "USER1", "CHANNEL1"

      described_class.find_conversation "USER1", "CHANNEL1"
    end
  end

  describe ".register_conversation" do
    let(:conversation) { double(:conversation) }

    it "delegates to the conversation factory" do
      expect(Converse::ConversationFactory.instance).to receive(:register).with conversation

      described_class.register_conversation conversation
    end
  end

  describe ".unregister_conversation" do
    let(:conversation) { double(:conversation) }

    it "delegates to the conversation factory" do
      expect(Converse::ConversationFactory.instance).to receive(:unregister).with conversation

      described_class.unregister_conversation conversation
    end
  end
end
