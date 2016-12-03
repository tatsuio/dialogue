RSpec.describe Converse::DSL do
  describe ".run" do
    let(:block) do
      Proc.new do
        on(:blah) {}
      end
    end

    it "supports an `on` method that defines the intent" do
      expect_any_instance_of(described_class).to receive(:on).with(:blah)

      described_class.run block
    end
  end
end
