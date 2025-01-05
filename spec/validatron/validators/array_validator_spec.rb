RSpec.describe Validatron::Validators::ArrayValidator do
  let(:errors) { {} }

  describe "#validate negative cases" do
    context "when value is not an array" do
      it "adds error" do
        validator = described_class.new(:tags, "string", { type: :array }, errors)
        validator.validate
        expect(errors[:tags]).to eq("must be an array")
      end
    end

    context "when required is true and value is nil" do
      it "adds error" do
        validator = described_class.new(:tags, nil, { type: :array, required: true }, errors)
        validator.validate
        expect(errors[:tags]).to eq("is required")
      end
    end

    context "when value does not have the exact length" do
      it "adds error" do
        validator = described_class.new(:tags, [1, 2, 3], { type: :array, length: 2 }, errors)
        validator.validate
        expect(errors[:tags]).to eq("must have exactly 2 items")
      end
    end

    context "when value does not have the minimum length" do
      it "adds error" do
        validator = described_class.new(:tags, [1], { type: :array, min: 2 }, errors)
        validator.validate
        expect(errors[:tags]).to eq("must have at least 2 items")
      end
    end

    context "when value does not have the maximum length" do
      it "adds error" do
        validator = described_class.new(:tags, [1, 2, 3], { type: :array, max: 2 }, errors)
        validator.validate
        expect(errors[:tags]).to eq("must have at most 2 items")
      end
    end

    context "when there are duplicate values" do
      it "adds error" do
        validator = described_class.new(:tags, [1, 1, 2], { type: :array, unique: true }, errors)
        validator.validate
        expect(errors[:tags]).to eq("must have unique items")
      end
    end

    context "when value does not have items that match the schema" do
      it "adds error" do
        validator = described_class.new(:tags, [1, 2, 3], { type: :array, items: { type: :string } }, errors)
        validator.validate

        expect(errors[:"tags[0]"]).to eq("must be a string")
        expect(errors[:"tags[1]"]).to eq("must be a string")
        expect(errors[:"tags[2]"]).to eq("must be a string")
      end
    end

    context "when value does not have items that match the schema with custom message" do
      it "adds error" do
        validator = described_class.new(
          :tags,
          [1, 2, 3],
          { type: :array, items: { type: :string, message: "custom message" } },
          errors
        )
        validator.validate

        expect(errors[:"tags[0]"]).to eq("custom message")
        expect(errors[:"tags[1]"]).to eq("custom message")
        expect(errors[:"tags[2]"]).to eq("custom message")
      end
    end

    context "when value has nested array of hashes" do
      it "adds error when nested array items do not match the schema" do
        validator = described_class.new(
          :tags,
          [{ name: 123 }, { name: 123 }],
          { type: :array, items: { type: :hash, keys: { name: { type: :string } } } },
          errors
        )
        validator.validate

        expect(errors[:"tags[0].name"]).to eq("must be a string")
        expect(errors[:"tags[1].name"]).to eq("must be a string")
      end

      it "adds error when nested array items do not match the schema with custom message" do
        validator = described_class.new(
          :tags,
          [{ name: "123" }, { name: 123 }],
          { type: :array, items: { type: :hash, keys: { name: { type: :string, message: "custom message" } } } },
          errors
        )
        validator.validate

        expect(errors[:"tags[1].name"]).to eq("custom message")
      end

      it "adds error when deep nested array items do not match the schema" do
        validator = described_class.new(
          :tags,
          [{ items: [{ name: 123 }] }],
          { type: :array, items: {
            type: :hash, keys: { items: { type: :array, items: { type: :hash, keys: { name: { type: :string } } } } }
          } },
          errors
        )
        validator.validate

        expect(errors[:"tags[0].items[0].name"]).to eq("must be a string")
      end
    end
  end

  describe "#validate positive cases" do
    context "when value is a valid array" do
      it "does not add error" do
        validator = described_class.new(:tags, [1, 2, 3], { type: :array }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has the exact length" do
      it "does not add error" do
        validator = described_class.new(:tags, [1, 2], { type: :array, length: 2 }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has the minimum length" do
      it "does not add error" do
        validator = described_class.new(:tags, [1, 2], { type: :array, min: 2 }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has the maximum length" do
      it "does not add error" do
        validator = described_class.new(:tags, [1, 2], { type: :array, max: 2 }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when there are no duplicate values" do
      it "does not add error" do
        validator = described_class.new(:tags, [1, 2, 3], { type: :array, unique: true }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has items that match the schema" do
      it "does not add error" do
        validator = described_class.new(:tags, %w[1 2 3], { type: :array, items: { type: :string } }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when value has items that match the schema with custom message" do
      it "does not add error" do
        validator = described_class.new(
          :tags,
          %w[1 2 3],
          { type: :array, items: { type: :string, message: "custom message" } },
          errors
        )
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when the values are empty" do
      it "does not add error" do
        validator = described_class.new(:tags, [], { type: :array }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end

    context "when the values are nil" do
      it "does not add error" do
        validator = described_class.new(:tags, nil, { type: :array }, errors)
        validator.validate
        expect(errors).to be_empty
      end
    end
  end
end
