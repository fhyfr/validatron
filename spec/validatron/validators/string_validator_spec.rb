RSpec.describe Validatron::Validators::StringValidator do
  let(:errors) { {} }

  describe "#validate negative cases" do
    context "when the value is nil" do
      it "does not add an error" do
        described_class.new(:name, nil, { type: :string }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when required is true and the value is nil" do
      it "adds an error" do
        described_class.new(:name, nil, { type: :string, required: true }, errors).validate

        expect(errors[:name]).to eq("is required")
      end
    end

    context "when the value is not a string" do
      it "adds an error" do
        described_class.new(:name, 123, { type: :string }, errors).validate
        expect(errors[:name]).to eq("must be a string")
      end
    end

    context "when the value is less than the minimum length" do
      it "adds an error" do
        described_class.new(:name, "a", { type: :string, min: 2 }, errors).validate
        expect(errors[:name]).to eq("must be at least 2 characters long")
      end
    end

    context "when the value is greater than the maximum length" do
      it "adds an error" do
        described_class.new(:name, "abc", { type: :string, max: 2 }, errors).validate
        expect(errors[:name]).to eq("must be at most 2 characters long")
      end
    end

    context "when the value is not the exact length" do
      it "adds an error" do
        described_class.new(:name, "abcd", { type: :string, length: 3 }, errors).validate
        expect(errors[:name]).to eq("must be exactly 3 characters long")
      end
    end

    context "when the value does not match the pattern" do
      it "adds an error" do
        described_class.new(:name, "123", { type: :string, pattern: /^[a-z]+$/ }, errors).validate
        expect(errors[:name]).to eq("is invalid")
      end
    end
  end

  describe "#validate positive cases" do
    context "when a custom message is provided" do
      it "uses the custom message" do
        described_class.new(:name, 123, { type: :string, message: "custom message" }, errors).validate
        expect(errors[:name]).to eq("custom message")
      end
    end

    context "when the value is a valid string" do
      it "does not add an error" do
        described_class.new(:name, "John", { type: :string }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when the value is a valid string with a minimum length" do
      it "does not add an error" do
        described_class.new(:name, "John", { type: :string, min: 1 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when the value is a valid string with a maximum length" do
      it "does not add an error" do
        described_class.new(:name, "John", { type: :string, max: 10 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when the value is a valid string with an exact length" do
      it "does not add an error" do
        described_class.new(:name, "John", { type: :string, length: 4 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when the value is a valid string that matches the pattern" do
      it "does not add an error" do
        described_class.new(:name, "abc", { type: :string, pattern: /^[a-z]+$/ }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is nil" do
      it "does not add an error" do
        described_class.new(:name, nil, { type: :string }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when required is false and value is nil" do
      it "does not add an error" do
        described_class.new(:name, nil, { type: :string, optional: true }, errors).validate
        expect(errors).to be_empty
      end
    end
  end
end
