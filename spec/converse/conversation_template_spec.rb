RSpec.describe Converse::ConversationTemplate do
  describe ".build" do
    let(:name) { :thread_one }
    after { Converse.clear_templates }

    it "returns a new instance of a template" do
      expect(described_class.build(name)).to be_kind_of Converse::ConversationTemplate
    end

    it "creates a new template each time" do
      run1 = described_class.build name
      run2 = described_class.build :thread_two

      expect(run1).to_not eq run2
    end

    it "can be initialized with a block" do
      proc = Proc.new {}

      subject = described_class.build name, &proc

      expect(subject.template).to eq proc
    end

    it "does not run the block" do
      ran = false
      proc = Proc.new { ran = true }

      subject = described_class.build name, &proc

      expect(ran).to eq false
    end

    it "takes in an optional thread name" do
      expect(described_class.build(:thread_one).name).to eq :thread_one
    end

    it "is registered with the template factory" do
      expect(Converse).to receive(:register_template).with(Converse::ConversationTemplate)

      described_class.build :thread_one
    end
  end

  describe "#start" do
    let(:channel_id) { "CHANNEL1" }
    let(:message) { double(:message, user: user_id, channel: channel_id) }
    let(:user_id) { "USER1" }

    it "delegates the creation of the conversation to the template runner" do
      expect(Converse::ConversationTemplateRunner).to receive(:new).with(message, {})
        .and_call_original
      expect_any_instance_of(Converse::ConversationTemplateRunner).to receive(:run).with(subject)

      subject.start message
    end
  end
end
