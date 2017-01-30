RSpec.describe Converse::ConversationFactory do
  before { described_class.shutdown }

  describe ".conversations" do
    it "returns an empty array" do
      described_class.shutdown

      expect(described_class.conversations).to be_empty
    end
  end

  describe ".shutdown" do
    before { described_class.startup }

    it "changes the status to dormant" do
      described_class.shutdown

      expect(described_class).to be_dormant
    end

    it "kills the thread" do
      expect(Thread).to receive(:kill).and_call_original

      described_class.shutdown
    end

    it "clears the conversations" do
      described_class.conversations << double(:conversation)

      described_class.shutdown

      expect(described_class.conversations).to be_empty
    end
  end

  describe ".startup" do
    before(:each) { described_class.shutdown }
    after(:each) { described_class.shutdown }

    it "has a started status" do
      described_class.startup

      expect(described_class).to be_running
    end

    it "returns a new thread that it starts" do
      expect(described_class.startup).to be_kind_of Thread
    end

    it "does not create another thread if it is already started" do
      described_class.startup

      expect(Thread).to_not receive(:new)

      described_class.startup
    end
  end
end
