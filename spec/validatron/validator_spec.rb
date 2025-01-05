RSpec.describe Validatron::Validator do
  let(:schema) do
    Validatron::Schema.new(
      {
        name: Validatron::Schema.string.min(1).max(10).required,
        age: Validatron::Schema.number.default(10).gte(0),
        email: Validatron::Schema.string.required,
        website: Validatron::Schema.string,
        tags: Validatron::Schema.array.items(Validatron::Schema.string.build).unique,
        contact_info: Validatron::Schema.array.items(
          Validatron::Schema.hash.keys(
            phone: Validatron::Schema.string.required.build,
            address: Validatron::Schema.string.required.build,
            social_media: Validatron::Schema.hash.keys(
              twitter: Validatron::Schema.string.build
            ).build
          ).build
        )
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

  it "raises error for missing required field in array of hashes" do
    params = { name: "John", email: "john@example.com", contact_info: [{ phone: "123" }] } # Missing address in the first hash
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /contact_info\[0\].address is required/)
  end

  it "raises error for incorrect type in array of hashes" do
    params = { name: "John", email: "john@example.com", contact_info: [{ phone: "123", address: 456 }] } # address should be a string
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /contact_info\[0\].address must be a string/)
  end

  it "passes validation for valid array of hashes" do
    params = { name: "John", email: "john@example.com", contact_info: [{ phone: "123", address: "123 Street" }] }
    Validatron::Validator.validate(params, schema)
    expect(params[:contact_info].first[:phone]).to eq("123")
    expect(params[:contact_info].first[:address]).to eq("123 Street")
  end

  it "raises error for incorrect type in hash" do
    params = { name: "John", email: "john@example.com", website: 123 } # website should be a string
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /website must be a string/)
  end

  it "raises error for incorrect type in nested hash" do
    params = { name: "John", email: "john@example.com", contact_info: [{ phone: "123", address: 123 }] } # address should be a string
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /contact_info\[0\].address must be a string/)
  end

  it "raises error for incorrect type in deep nested hash" do
    params = { name: "John", email: "john@example.com", contact_info: [{ phone: "123", address: "123 Street", social_media: { twitter: 123 } }] } # twitter should be a string
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /contact_info\[0\].social_media.twitter must be a string/)
  end
end
