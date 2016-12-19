RSpec.describe Converse do
  describe ".build" do
    it "runs the DSL with the specified block" do
      block = Proc.new {}

      expect(Converse::DSL).to receive(:run).with(block)

      described_class.build &block
    end
  end

  describe ".clear_conversations" do
    let(:conversation) { double(:conversation) }

    it "removes all the conversations from memory" do
      described_class.register_conversation conversation

      described_class.clear_conversations

      expect(described_class.conversations).to be_empty
    end
  end
end
