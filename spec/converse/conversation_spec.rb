RSpec.describe Converse::Conversation do
  describe "#initialize" do
    it "can initialize with a block" do
      proc = Proc.new { }

      expect(described_class.new(&proc).current_step).to eq proc
    end
  end

  describe "#ask" do
    it "sets the current step to be the current block" do
      proc = Proc.new { }

      subject.ask("Are you ok?", &proc)

      expect(subject.current_step).to eq proc
    end

    it "streams the message to slack by default" do
      question = "Are you ok?"

      expect_any_instance_of(Converse::Streams::Slack).to \
        receive(:puts).with(question)

      subject.ask question
    end
  end

  describe "say" do
    it "streams the message" do
      statement = "Hello world"

      expect_any_instance_of(Converse::Streams::Slack).to \
        receive(:puts).with(statement)

      subject.say statement
    end
  end

  describe "#start" do
    let(:channel_id) { "C12345" }
    let(:message) { double(:message, user: user_id, channel: channel_id) }
    let(:user_id) { "U12345" }

    before { Converse.clear_conversations }

    it "sets the user and channel" do
      subject.start message

      expect(subject.channel_id).to eq channel_id
      expect(subject.user_id).to eq user_id
    end

    it "adds the conversation to the factory" do
      subject.start message

      expect(Converse.conversations.count).to eq 1
      expect(Converse.conversations.last).to eq subject
    end

    it "performs the current step" do
      ran = false
      subject = described_class.new { ran = true }

      subject.start message

      expect(ran).to eq true
    end

    it "passes the conversation when the current step is performed" do
      conversation = nil
      subject = described_class.new { |c| conversation = c }

      subject.start message

      expect(conversation).to eq subject
    end

    context "for a conversation that is already in the factory" do
      it "does not add it again" do
        allow(subject).to \
          receive_messages(user_id: user_id, channel_id: channel_id)
        Converse.register_conversation subject

        subject.start message

        expect(Converse.conversations.count).to eq 1
      end
    end
  end
end
