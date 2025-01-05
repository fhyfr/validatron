RSpec.describe Validatron::RuleBuilder do
  it "builds a string rule with min and max" do
    rule = Validatron::RuleBuilder.new(:string).min(1).max(10).build
    expect(rule).to eq({ type: :string, min: 1, max: 10 })
  end

  it "builds a number rule with default and gte" do
    rule = Validatron::RuleBuilder.new(:number).default(10).gte(0).build
    expect(rule).to eq({ type: :number, default: 10, gte: 0 })
  end

  it "builds a boolean rule with required" do
    rule = Validatron::RuleBuilder.new(:boolean).required.build
    expect(rule).to eq({ type: :boolean, required: true })
  end

  it "builds a date rule with optional" do
    rule = Validatron::RuleBuilder.new(:date).optional.build
    expect(rule).to eq({ type: :date, required: false })
  end

  it "builds an array rule with unique items" do
    rule = Validatron::RuleBuilder.new(:array).items(Validatron::RuleBuilder.new(:string).build).unique.build
    expect(rule).to eq({ type: :array, items: { type: :string }, unique: true })
  end

  it "builds an hash rule with nested keys" do
    rule = Validatron::RuleBuilder.new(:hash).keys(
      {
        street: Validatron::RuleBuilder.new(:string).required.build,
        city: Validatron::RuleBuilder.new(:string).required.build,
        zip: Validatron::RuleBuilder.new(:string).pattern(/\A\d{5}\z/).required.build
      }
    ).build

    expect(rule).to eq(
      {
        type: :hash,
        keys: {
          street: { type: :string, required: true },
          city: { type: :string, required: true },
          zip: { type: :string, pattern: /\A\d{5}\z/, required: true }
        }
      }
    )
  end
end
