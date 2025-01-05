RSpec.describe Validatron::Validator do
  let(:schema) do
    Validatron::Schema.new(
      {
        name: Validatron::Schema.string.min(1).max(10).required,
        age: Validatron::Schema.number.default(10).gte(0),
        email: Validatron::Schema.string.required,
        website: Validatron::Schema.string,
        tags: Validatron::Schema.array.items(Validatron::Schema.string).unique
        # TODO: add test for array of objects
      }
    )
  end

  it "assigns default value if field is missing" do
    params = { name: "John", email: "john@example.com" }
    Validatron::Validator.validate(params, schema)
    expect(params[:age]).to eq(10)
  end

  it "does not assign default value if field is provided" do
    params = { name: "John", age: 25, email: "john@example.com" }
    Validatron::Validator.validate(params, schema)
    expect(params[:age]).to eq(25)
  end

  it "raises error for incorrect type (integer instead of string)" do
    params = { name: 123, email: "john@example.com" }
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /name must be a string/)
  end

  it "raises error for input less than min" do
    params = { name: "John", age: -1, email: "john@example.com" }
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /age must be greater than or equal to 0/)
  end

  it "raises error for non-unique items in array" do
    params = { name: "John", email: "john@example.com", tags: %w[ruby ruby] }
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /tags must have unique items/)
  end

  # TODO: add test for array of objects
end
