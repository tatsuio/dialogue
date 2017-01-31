RSpec.describe Converse::Factory do
  let(:channel_id) { "CHANNEL1" }
  let(:conversation) { double(:conversation, user_id: user_id, channel_id: channel_id) }
  let(:user_id) { "USER1" }
  subject { described_class.instance }

  it "is a singleton" do
    expect { described_class.new }.to raise_error NoMethodError
  end

  describe "#initialize" do
    it "is initialized with an empty array of conversations" do
      expect(subject.conversations).to be_empty
    end
  end

  describe "#find" do
    after { subject.conversations.clear }

    it "finds a conversation with the specified user id and channel id" do
      subject.conversations << conversation

      expect(subject.find(user_id, channel_id)).to eq conversation
    end

    it "returns nil if the conversation can't be found" do
      expect(subject.find(user_id, channel_id)).to be_nil
    end
  end

  describe "#register" do
    after { subject.conversations.clear }

    it "adds the conversation to the list of active conversations" do
      subject.register conversation

      expect(subject.conversations).to include conversation
    end

    it "does not register the conversation if one already exists for the user and channel" do
      subject.register conversation

      expect { subject.register conversation }.to_not change { subject.conversations.count }
    end
  end

  describe "#registered?" do
    after { subject.conversations.clear }

    it "is registered if the conversation with the user and channel exists" do
      subject.register conversation

      expect(subject).to be_registered user_id, channel_id
    end

    it "is not registered if the conversation with the user and channel does not exist" do
      expect(subject).to_not be_registered user_id, channel_id
    end
  end

  describe "#unregister" do
    after { subject.conversations.clear }

    it "is removed if the conversation with the user and channel exists" do
      subject.register conversation

      subject.unregister conversation

      expect(subject).to_not be_registered user_id, channel_id
    end

    it "is not removed if the conversation with the user and channel does not exist" do
      expect { subject.unregister conversation }.to_not change { subject.conversations.count }
    end
  end
end
