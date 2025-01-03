RSpec.describe Validatron::Validators::NumberValidator do
  let(:errors) { {} }

  it "validates a number" do
    validator = described_class.new(:age, 25, { type: :number }, errors)
    validator.validate
    expect(errors).to be_empty
  end

  it "adds an error for non-numeric values" do
    validator = described_class.new(:age, "25", { type: :number }, errors)
    validator.validate
    expect(errors[:age]).to eq("must be a number")
  end

  it "adds an error for numbers less than min" do
    validator = described_class.new(:age, 25, { type: :number, min: 30 }, errors)
    validator.validate
    expect(errors[:age]).to eq("must be at least 30")
  end

  it "adds an error for numbers greater than max" do
    validator = described_class.new(:age, 25, { type: :number, max: 20 }, errors)
    validator.validate
    expect(errors[:age]).to eq("must be at most 20")
  end

  it "adds an error for non-integers" do
    validator = described_class.new(:age, 25.5, { type: :number, integer: true }, errors)
    validator.validate
    expect(errors[:age]).to eq("must be an integer")
  end

  it "adds an error for non-floats" do
    validator = described_class.new(:age, 25, { type: :number, float: true }, errors)
    validator.validate
    expect(errors[:age]).to eq("must be a float")
  end

  it "adds an error for non-positive numbers" do
    validator = described_class.new(:age, 0, { type: :number, positive: true }, errors)
    validator.validate
    expect(errors[:age]).to eq("must be positive")
  end

  it "adds an error for non-negative numbers" do
    validator = described_class.new(:age, 5, { type: :number, negative: true }, errors)
    validator.validate
    expect(errors[:age]).to eq("must be negative")
  end

  it "adds an error for numbers with incorrect precision" do
    validator = described_class.new(:age, 25.123, { type: :number, precision: 2 }, errors)
    validator.validate
    expect(errors[:age]).to eq("must have 2 decimal places")
  end
end
