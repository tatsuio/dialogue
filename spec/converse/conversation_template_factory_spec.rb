RSpec.describe Converse::TemplateFactory do
  let(:name) { :select_size }
  let(:template) { double(:template, name: name) }
  subject { described_class.instance }

  it "is a singleton" do
    expect { described_class.new }.to raise_error NoMethodError
  end

  describe "#initialize" do
    it "is initialized with an empty array of templates" do
      expect(subject.templates).to be_empty
    end
  end

  describe "#find" do
    after { subject.templates.clear }

    it "finds a template with the specified name" do
      subject.templates << template

      expect(subject.find("select_size")).to eq template
    end

    it "returns nil if the template can't be found" do
      expect(subject.find(name)).to be_nil
    end
  end

  describe "#register" do
    after { subject.templates.clear }

    it "adds the template to the list of templates" do
      subject.register template

      expect(subject.templates).to include template
    end

    it "raises a TemplateAlreadyRegisteredError if the template name is already registered" do
      subject.register template

      expect { subject.register template }.to raise_error Converse::TemplateAlreadyRegisteredError
    end
  end

  describe "#registered?" do
    after { subject.templates.clear }

    it "returns true if the template is registered" do
      subject.register template

      expect(subject).to be_registered template
    end

    it "returns false if the template is not registered" do
      expect(subject).to_not be_registered template
    end
  end
end
