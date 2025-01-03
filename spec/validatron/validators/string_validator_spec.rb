RSpec.describe Validatron::Validators::StringValidator do
  let(:errors) { {} }

  it "validates a string" do
    validator = described_class.new(:name, "John", { type: :string }, errors)
    validator.validate
    expect(errors).to be_empty
  end

  it "adds an error for non-string values" do
    validator = described_class.new(:name, 123, { type: :string }, errors)
    validator.validate
    expect(errors[:name]).to eq("must be a string")
  end

  it "adds an error for strings shorter than min length" do
    validator = described_class.new(:name, "Jo", { type: :string, min: 3 }, errors)
    validator.validate
    expect(errors[:name]).to eq("must be at least 3 characters long")
  end

  it "adds an error for strings longer than max length" do
    validator = described_class.new(:name, "John Doe", { type: :string, max: 5 }, errors)
    validator.validate
    expect(errors[:name]).to eq("must be at most 5 characters long")
  end

  it "adds an error for strings not matching length" do
    validator = described_class.new(:name, "John", { type: :string, length: 5 }, errors)
    validator.validate
    expect(errors[:name]).to eq("must be exactly 5 characters long")
  end

  it "adds an error for strings not matching pattern" do
    validator = described_class.new(:name, "John", { type: :string, pattern: /\d+/ }, errors)
    validator.validate
    expect(errors[:name]).to eq("is invalid")
  end
end
