require "validatron/schema"

RSpec.describe Validatron::Validator do
  let(:schema) do
    schema = Validatron::Schema.new
    schema.required(:name, type: :string)
    schema.required(:email, type: :string)
    schema.optional(:age, type: :number, min: 0, default: 18)
    schema
  end

  it "raises error for missing type" do
    schema = Validatron::Schema.new
    schema.required(:name)
    schema.required(:email, type: :string)

    params = { name: "John", email: "john@example.com" }
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /must have a type defined/)
  end

  it "raises custom error message for missing required parameters" do
    schema_with_custom_message = Validatron::Schema.new
    schema_with_custom_message.required(:name, type: :string, message: "Name is required")
    schema_with_custom_message.required(:email, type: :string, message: "Email is required")

    params = { email: "john@example.com" }
    expect { Validatron::Validator.validate(params, schema_with_custom_message) }
      .to raise_error(Validatron::ValidationError, /Name is required/)
  end

  it "raises custom error message for optional parameters" do
    schema_with_custom_message = Validatron::Schema.new
    schema_with_custom_message.required(:name, type: :string)
    schema_with_custom_message.optional(:age, type: :number, min: 0, default: 18, message: "Age must be greater than 0")

    params = { name: "John", age: -1 }
    expect { Validatron::Validator.validate(params, schema_with_custom_message) }
      .to raise_error(Validatron::ValidationError, /Age must be greater than 0/)
  end

  it "raises error for unknown type" do
    schema = Validatron::Schema.new
    schema.required(:name, type: :unknown)
    schema.required(:email, type: :string)

    params = { name: "John", email: "john@example.com" }
    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /Unknown type: unknown/)
  end

  it "assigns default value if field is missing" do
    params = { name: "John", email: "john@example.com" }
    Validatron::Validator.validate(params, schema)
    expect(params[:age]).to eq(18)
  end

  it "does not assign default value if field is provided" do
    params = { name: "John", email: "john@example.com", age: 25 }
    Validatron::Validator.validate(params, schema)
    expect(params[:age]).to eq(25)
  end
end
