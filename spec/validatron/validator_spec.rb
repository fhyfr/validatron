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
end
