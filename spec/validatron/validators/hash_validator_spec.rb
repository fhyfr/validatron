RSpec.describe Validatron::Validators::HashValidator do
  let(:errors) { {} }

  describe "#validate negative cases" do
    context "when value is not a hash" do
      it "adds error" do
        validator = described_class.new(:name, "John", { type: :hash }, errors)
        validator.validate
        expect(errors[:name]).to eq("must be a hash")
      end

      it "adds custom error message" do
        validator = described_class.new(:name, "John", { type: :hash, message: "custom message" }, errors)
        validator.validate

        expect(errors[:name]).to eq("custom message")
      end
    end

    context "when value is required and value is nil" do
      it "adds error" do
        validator = described_class.new(:name, nil, { type: :hash, required: true }, errors)
        validator.validate

        expect(errors[:name]).to eq("is required")
      end
    end

    context "when value has keys with schema and one key is invalid" do
      it "adds error" do
        validator = described_class.new(
          :name,
          { first: 123, last: "123" },
          { type: :hash, keys: { first: { type: :string }, last: { type: :string } } },
          errors
        )
        validator.validate

        expect(errors[:"name.first"]).to eq("must be a string")
      end
    end

    context "when value has keys with schema and multiple keys are invalid" do
      it "adds errors" do
        validator = described_class.new(
          :name,
          { first: 123, last: 123 },
          { type: :hash, keys: { first: { type: :string }, last: { type: :string } } },
          errors
        )
        validator.validate

        expect(errors[:"name.first"]).to eq("must be a string")
        expect(errors[:"name.last"]).to eq("must be a string")
      end
    end

    context "when value has keys with schema and multiple keys are invalid" do
      it "adds error for each keys" do
        validator = described_class.new(
          :name,
          { first: 123, last: 123 },
          {
            type: :hash,
            keys: {
              first: { type: :string, message: "custom message 1" },
              last: { type: :string, message: "custom message 2" }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.first"]).to eq("custom message 1")
        expect(errors[:"name.last"]).to eq("custom message 2")
      end
    end

    context "when value has nested hash and nested hash is invalid" do
      it "adds error" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", address: { city: 123 } },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              address: { type: :hash, keys: { city: { type: :string } } }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.address.city"]).to eq("must be a string")
      end

      it "adds custom error message" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", address: { city: 123 } },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              address: { type: :hash, keys: { city: { type: :string, message: "custom message" } } }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.address.city"]).to eq("custom message")
      end

      it "adds error for each nested hash keys" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", address: { city: 123, zip: 123 } },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              address: {
                type: :hash,
                keys: {
                  city: { type: :string },
                  zip: { type: :string }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.address.city"]).to eq("must be a string")
        expect(errors[:"name.address.zip"]).to eq("must be a string")
      end

      it "adds custom error message for each nested hash keys" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", address: { city: 123, zip: 123 } },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              address: {
                type: :hash,
                keys: {
                  city: { type: :string, message: "custom message 1" },
                  zip: { type: :string, message: "custom message 2" }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.address.city"]).to eq("custom message 1")
        expect(errors[:"name.address.zip"]).to eq("custom message 2")
      end

      it "adds error for complex nested combination of hash and array" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", addresses: [{ city: 123 }] },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string } }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.addresses[0].city"]).to eq("must be a string")
      end

      it "adds custom error message for complex nested combination of hash and array" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", addresses: [{ city: 123 }] },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string, message: "custom message" } }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.addresses[0].city"]).to eq("custom message")
      end

      it "adds error for complex nested combination of hash and array with multiple items" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", addresses: [{ city: 123 }, { city: 123 }] },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string } }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.addresses[0].city"]).to eq("must be a string")
        expect(errors[:"name.addresses[1].city"]).to eq("must be a string")
      end

      it "adds custom error message for complex nested combination of hash and array with multiple items" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", addresses: [{ city: 123 }, { city: 123 }] },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string, message: "custom message" } }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.addresses[0].city"]).to eq("custom message")
        expect(errors[:"name.addresses[1].city"]).to eq("custom message")
      end

      it "adds error for complex nested combination of hash and array with multiple items and multiple keys" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", addresses: [{ city: 123, zip: 123 }, { city: 123, zip: 123 }] },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string }, zip: { type: :string } }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.addresses[0].city"]).to eq("must be a string")
        expect(errors[:"name.addresses[0].zip"]).to eq("must be a string")
        expect(errors[:"name.addresses[1].city"]).to eq("must be a string")
        expect(errors[:"name.addresses[1].zip"]).to eq("must be a string")
      end
    end

    context "when value has deep complex combination of nested hash and array" do
      it "adds error" do
        validator = described_class.new(
          :name,
          {
            first: "John",
            last: "Doe",
            addresses: [{ city: 123, zip: 123 }, { city: 123, zip: 123 }],
            contacts: [{ phone: 123 }, { phone: 123 }]
          },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string }, zip: { type: :string } }
                }
              },
              contacts: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { phone: { type: :string } }
                }
              }
            }
          },
          errors
        )
        validator.validate

        expect(errors[:"name.addresses[0].city"]).to eq("must be a string")
        expect(errors[:"name.addresses[0].zip"]).to eq("must be a string")
      end
    end
  end

  describe "#validate positive cases" do
    context "when value is a valid hash" do
      it "does not add error" do
        validator = described_class.new(:name, { first: "John", last: "Doe" }, { type: :hash }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has keys with schema" do
      it "does not add error" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe" },
          { type: :hash, keys: { first: { type: :string }, last: { type: :string } } },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end

      it "does not add error with custom message" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe" },
          {
            type: :hash,
            keys: {
              first: { type: :string, message: "custom message 1" },
              last: { type: :string, message: "custom message 2" }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end

      it "does not add error if each keys has different schema" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", age: 25 },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string, min: 1 },
              age: { type: :number, min: 0 }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end

      it "does not add error if each keys has different schema with custom message" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", age: 25 },
          {
            type: :hash,
            keys: {
              first: { type: :string, message: "custom message 1" },
              last: { type: :string, min: 1, message: "custom message 2" },
              age: { type: :number, min: 0, message: "custom message 3" }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has nested hash" do
      it "does not add error" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", address: { city: "New York" } },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              address: { type: :hash, keys: { city: { type: :string } } }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end

      it "does not add error with custom message" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", address: { city: "New York" } },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              address: {
                type: :hash,
                keys: { city: { type: :string, message: "custom message" } }
              }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end

      it "does not add error if nested hash has multiple keys" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", address: { city: "New York", zip: "10001" } },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              address: {
                type: :hash,
                keys: {
                  city: { type: :string },
                  zip: { type: :string, pattern: /\A\d{5}\z/ }
                }
              }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end

      it "does not add error if nested has with nested array of hash" do
        validator = described_class.new(
          :name,
          { first: "John", last: "Doe", addresses: [{ city: "New York" }, { city: "Los Angeles" }] },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string } }
                }
              }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has complex nested hash and array" do
      it "does not add error" do
        validator = described_class.new(
          :name,
          {
            first: "John",
            last: "Doe",
            addresses: [{ city: "New York" }, { city: "Los Angeles" }],
            contacts: [{ email: "john@example.com" }, { email: "john2@example.com" }, { email: "john3@example.com" }]
          },
          {
            type: :hash,
            keys: {
              first: { type: :string },
              last: { type: :string },
              addresses: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { city: { type: :string } }
                }
              },
              contacts: {
                type: :array,
                items: {
                  type: :hash,
                  keys: { email: { type: :string, email: true } }
                }
              }
            }
          },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value is empty" do
      it "does not add error" do
        validator = described_class.new(:name, {}, { type: :hash }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value is nil" do
      it "does not add error" do
        validator = described_class.new(:name, nil, { type: :hash }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end
  end
end
