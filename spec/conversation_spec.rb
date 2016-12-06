RSpec.describe Converse::Conversation do
  let(:message) { double(:message) }
  subject { described_class.new(message) }

  describe "#initialize" do
    it "initializes with a message" do
      subject = described_class.new message

      expect(subject.message).to eq message
    end
  end

  describe "#handle!" do
    it "delegates to a conversation handler" do
      expect(Converse::ConversationHandler).to receive(:handle!).with(message)

      subject.handle!
    end

    it "returns true if the conversation was handled" do
      allow(Converse::ConversationHandler).to receive(:handle!).and_return true

      expect(subject.handle!).to be_truthy
    end

    it "return false if the conversation was not handled" do
      allow(Converse::ConversationHandler).to receive(:handle!).and_return false

      expect(subject.handle!).to be_falsey
    end
  end
end
