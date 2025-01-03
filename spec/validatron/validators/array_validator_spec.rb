RSpec.describe Validatron::Validators::ArrayValidator do
  let(:errors) { {} }

  it "validates an array" do
    validator = described_class.new(:tags, %w[ruby rails], { type: :array }, errors)
    validator.validate
    expect(errors).to be_empty
  end

  it "adds an error for non-array values" do
    validator = described_class.new(:tags, "ruby", { type: :array }, errors)
    validator.validate
    expect(errors[:tags]).to eq("must be an array")
  end

  it "adds an error for arrays shorter than min length" do
    validator = described_class.new(:tags, ["ruby"], { type: :array, min: 2 }, errors)
    validator.validate
    expect(errors[:tags]).to eq("must have at least 2 items")
  end

  it "adds an error for arrays longer than max length" do
    validator = described_class.new(:tags, %w[ruby rails sinatra], { type: :array, max: 2 }, errors)
    validator.validate
    expect(errors[:tags]).to eq("must have at most 2 items")
  end

  it "adds an error for arrays not matching length" do
    validator = described_class.new(:tags, %w[ruby rails], { type: :array, length: 3 }, errors)
    validator.validate
    expect(errors[:tags]).to eq("must have exactly 3 items")
  end

  it "validates items in the array" do
    validator = described_class.new(:tags, ["ruby", 123], { type: :array, items: { type: :string } }, errors)
    validator.validate
    expect(errors[:"items[1].item"]).to eq("must be a string")

    errors.clear

    validator = described_class.new(:tags, %w[ruby rails], { type: :array, items: { type: :string } }, errors)
    validator.validate
    expect(errors).to be_empty

    errors.clear

    validator = described_class.new(:tags, %w[ruby rails], { type: :array, items: { type: :number } }, errors)
    validator.validate
    expect(errors[:"items[0].item"]).to eq("must be a number")
  end

  it "adds an error for non-unique items" do
    validator = described_class.new(:tags, %w[ruby ruby], { type: :array, unique: true }, errors)
    validator.validate
    expect(errors[:tags]).to eq("must have unique items")
  end
end
