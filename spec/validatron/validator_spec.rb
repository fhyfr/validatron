RSpec.describe Validatron::Validator do
  let(:schema) do
    schema = Validatron::Schema.new
    schema.required(:name, type: :string)
    schema.required(:email, type: :string)
    schema.optional(:age, type: :integer, gt: 0)
    schema
  end

  it "raises error for missing required parameters" do
    params = { email: "john@example.com" }

    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /name is required/)
  end

  it "raises error for missing type for required fields" do
    schema_without_type = Validatron::Schema.new
    schema_without_type.required(:name)

    params = { name: "John", email: "john@example.com" }

    expect { Validatron::Validator.validate(params, schema_without_type) }
      .to raise_error(Validatron::ValidationError, /name must have a type defined/)
  end

  it "raises error for incorrect type (boolean instead of string)" do
    params = { name: true, email: "john@example.com", age: 20 }

    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /name must be a string/)
  end

  it "raises error for incorrect type (integer instead of string)" do
    params = { name: 123, email: "john@example.com", age: 20 }

    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /name must be a string/)
  end

  it "raises error for incorrect type (string instead of integer)" do
    params = { name: "John", email: "john@example.com", age: "twenty" }

    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /age must be a integer/)
  end

  it "raises error for input less than gt" do
    params = { name: "John", email: "john@example.com", age: 0 }

    expect { Validatron::Validator.validate(params, schema) }
      .to raise_error(Validatron::ValidationError, /age must be greater than 0/)
  end

  it "raises custom error message for missing required parameters" do
    schema_with_custom_message = Validatron::Schema.new
    schema_with_custom_message.required(:name, type: :string, message: "Name is required")
    schema_with_custom_message.required(:email, type: :string, message: "Email is required")

    params = { email: "john@example.com" }
    expect { Validatron::Validator.validate(params, schema_with_custom_message) }
      .to raise_error(Validatron::ValidationError, /Name is required/)
  end

  it "raises error for input greater than lt" do
    schema_with_lt = Validatron::Schema.new
    schema_with_lt.optional(:age, type: :integer, lt: 10)

    params = { age: 20 }
    expect { Validatron::Validator.validate(params, schema_with_lt) }
      .to raise_error(Validatron::ValidationError, /age must be less than 10/)
  end

  it "raises error for input less than gte" do
    schema_with_gte = Validatron::Schema.new
    schema_with_gte.optional(:age, type: :integer, gte: 10)

    params = { age: 5 }
    expect { Validatron::Validator.validate(params, schema_with_gte) }
      .to raise_error(Validatron::ValidationError, /age must be greater than or equal to 10/)
  end

  it "raises error for input greater than lte" do
    schema_with_lte = Validatron::Schema.new
    schema_with_lte.optional(:age, type: :integer, lte: 10)

    params = { age: 15 }
    expect { Validatron::Validator.validate(params, schema_with_lte) }
      .to raise_error(Validatron::ValidationError, /age must be less than or equal to 10/)
  end

  it "raises error for input not equal to eq" do
    schema_with_eq = Validatron::Schema.new
    schema_with_eq.optional(:age, type: :integer, eq: 10)

    params = { age: 5 }
    expect { Validatron::Validator.validate(params, schema_with_eq) }
      .to raise_error(Validatron::ValidationError, /age must be equal to 10/)
  end
end
