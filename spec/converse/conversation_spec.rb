RSpec.describe Converse::Conversation do
  include Converse::Test::SlackClientStubbing

  describe "#initialize" do
    let(:proc) { Proc.new {} }
    let(:template) { Converse::ConversationTemplate.new &proc }
    subject { described_class.new template }

    it "is initialized with a template" do
      expect(subject.template).to eq template
    end

    it "sets the current step to the template" do
      expect(subject.steps.first).to eq proc
    end
  end

  describe "#ask" do
    let(:channel_id) { nil }
    let(:user_id) { nil }

    before { stub_slack_chat }

    it "sets the current step to be the current block" do
      proc = Proc.new { }

      subject.ask("Are you ok?", &proc)

      expect(subject.steps.last).to eq proc
    end

    it "streams the message to slack by default" do
      question = "Are you ok?"

      expect_any_instance_of(Converse::Streams::Slack).to \
        receive(:puts).with(question, channel_id, user_id, {})

      subject.ask question
    end
  end

  describe "#say" do
    let(:channel_id) { nil }
    let(:user_id) { nil }

    before { stub_slack_chat }

    it "streams the message" do
      statement = "Hello world"

      expect_any_instance_of(Converse::Streams::Slack).to \
        receive(:puts).with(statement, channel_id, user_id, {})

      subject.say statement
    end
  end

  describe "#perform" do
    let(:proc) { Proc.new {} }
    let(:template) { Converse::ConversationTemplate.new &proc }
    subject { described_class.new template }

    it "removes itself from the conversations if there are no more steps" do
      Converse.register_conversation subject

      expect { subject.perform }.to change { Converse.conversations.count }.by -1
    end

    it "yields the message" do
      message = double(:message)
      Converse.register_conversation subject

      expect(proc).to receive(:call).with(subject, message)

      subject.perform message
    end
  end
end
