RSpec.describe Converse::Conversation do
  include Converse::Test::SlackClientStubbing

  describe "#initialize" do
    let(:proc) { Proc.new {} }
    let(:message) { double(:message, channel_id: "C1", team_id: "T1", user_id: "U1") }
    let(:template) { Converse::ConversationTemplate.new &proc }
    subject { described_class.new template, message }

    it "is initialized with a template" do
      expect(subject.template).to eq template
    end

    it "sets the current step to the template" do
      expect(subject.steps.first).to eq proc
    end

    it "is initialized with a decorated message" do
      expect(subject.message).to eq message
    end

    it "sets the channel id" do
      expect(subject.channel_id).to eq "C1"
    end

    it "sets the team id" do
      expect(subject.team_id).to eq "T1"
    end

    it "sets the user id" do
      expect(subject.user_id).to eq "U1"
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

  describe "#data" do
    it "is initialized with an empty hash" do
      expect(subject.data).to be_empty
    end
  end

  describe "#diverge" do
    let(:another_template) { double(:template, name: :another_conversation) }

    xit "finds the conversation by name" do
      template = Converse::ConversationTemplate.build(:another_conversation)
      Converse.register_template template

      conversation = subject.diverge :another_conversation

      expect(conversation.template).to eq template
    end

    xit "calls the conversation with the channel and user"
    xit "does nothing if the conversation doesn't exist"
  end

  describe "#end" do
    let(:proc) { Proc.new {} }
    let(:template) { Converse::ConversationTemplate.new &proc }
    subject { described_class.new template }

    it "removes itself from the conversations" do
      Converse.register_conversation subject

      expect { subject.end }.to change { Converse.conversations.count }.by -1
    end

    it "can optionally say the last word" do
      expect(subject).to receive(:say).with "Bye-bye"

      subject.end "Bye-bye"
    end
  end

  describe "#fetch" do
    it "returns the value for the key in data" do
      subject.store!(data: :blah)

      expect(subject.fetch(:data)).to eq :blah
    end

    it "returns nil if the key is not found" do
      expect(subject.fetch(:data)).to be_nil
    end

    it "returns an optional default value" do
      expect(subject.fetch(:data, "go fish")).to eq "go fish"
    end

    it "returns the result of the block if provided" do
      expect(subject.fetch(:data) { "go fish" }).to eq "go fish"
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

  describe "#store!" do
    it "stores some data" do
      subject.store!(data: :blah)

      expect(subject.data).to eq({ data: :blah })
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
