RSpec.describe Validatron::Schema do
  it "builds a schema with various rules" do
    schema = Validatron::Schema.new(
      {
        name: Validatron::Schema.string.min(1).max(10).required,
        age: Validatron::Schema.number.default(10).gte(0),
        email: Validatron::Schema.string.email.required,
        website: Validatron::Schema.string.uri,
        tags: Validatron::Schema.array.items(Validatron::Schema.string.build).unique,
        address: Validatron::Schema.hash.keys(
          {
            street: Validatron::Schema.string.required.build,
            city: Validatron::Schema.string.required.build,
            zip: Validatron::Schema.string.pattern(/\A\d{5}\z/).required.build
          }
        )
      }
    )

    expect(schema.rules[:name]).to eq({ type: :string, min: 1, max: 10, required: true })
    expect(schema.rules[:age]).to eq({ type: :number, default: 10, gte: 0 })
    expect(schema.rules[:email]).to eq({ type: :string, email: true, required: true })
    expect(schema.rules[:website]).to eq({ type: :string, uri: true })
    expect(schema.rules[:tags]).to eq({ type: :array, items: { type: :string }, unique: true })
    expect(schema.rules[:address]).to eq(
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
