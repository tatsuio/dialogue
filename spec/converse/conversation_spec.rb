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
end
