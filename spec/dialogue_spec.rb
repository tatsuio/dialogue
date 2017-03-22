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

  describe ".clear_templates" do
    let(:template) { double(:template, name: "select_shirt") }

    it "removes all the templates from memory" do
      described_class.register_template template

      described_class.clear_templates

      expect(described_class.templates).to be_empty
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

  describe ".find_template" do
    it "delegates to the template factory" do
      expect(Converse::TemplateFactory.instance).to receive(:find).with "select_size"

      described_class.find_template "select_size"
    end
  end

  describe ".register_conversation" do
    let(:conversation) { double(:conversation) }

    it "delegates to the conversation factory" do
      expect(Converse::ConversationFactory.instance).to receive(:register).with conversation

      described_class.register_conversation conversation
    end
  end

  describe ".register_template" do
    let(:template) { double(:template) }

    it "delegates to the template factory" do
      expect(Converse::TemplateFactory.instance).to receive(:register).with template

      described_class.register_template template
    end
  end

  describe ".templates" do
    it "delegates to the template factory" do
      expect(Converse::TemplateFactory.instance).to receive(:templates)

      described_class.templates
    end
  end

  describe ".template_registered?" do
    let(:template) { double(:template, name: "select_shirt") }

    it "delegates to the template factory" do
      expect(Converse::TemplateFactory.instance).to receive(:registered?).with template.name

      described_class.template_registered? template.name
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
