RSpec.describe Validatron::Validators::BooleanValidator do
  let(:errors) { {} }

  it "validates a boolean" do
    validator = described_class.new(:active, true, { type: :boolean }, errors)
    validator.validate
    expect(errors).to be_empty
  end

  it "adds an error for non-boolean values" do
    validator = described_class.new(:active, "true", { type: :boolean }, errors)
    validator.validate
    expect(errors[:active]).to eq("must be a boolean")
  end

  it "adds an error for non-true values" do
    validator = described_class.new(:active, false, { type: :boolean, truthy: true }, errors)
    validator.validate
    expect(errors[:active]).to eq("must be true")
  end

  it "adds an error for non-false values" do
    validator = described_class.new(:active, true, { type: :boolean, falsy: true }, errors)
    validator.validate
    expect(errors[:active]).to eq("must be false")
  end
end
