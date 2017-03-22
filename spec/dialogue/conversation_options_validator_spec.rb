RSpec.describe Dialogue::ConversationOptionsValidator do
  describe "::VALID_OPTIONS" do
    it "returns the valid option keys" do
      expect(described_class::VALID_OPTIONS).to eq [:access_token, :author_id]
    end
  end

  describe "#validate" do
    it "returns a successful result if the options are empty" do
      expect(subject.validate({})).to be_success
    end

    it "returns a successful result if the options only contain valid options" do
      expect(subject.validate({ access_token: "BLAH" })).to be_success
    end

    it "returns an unsuccessful result if the options contain invalid options" do
      result = subject.validate({ blah: "BLAH" })

      expect(result).to_not be_success
      expect(result.errors).to eq ["blah is not a valid option"]
      expect(result.error_messages).to eq "blah is not a valid option"
    end
  end
end
