RSpec.describe Validatron::Validators::NumberValidator do
  let(:errors) { {} }

  describe "#validate negative cases" do
    context "when value is not a number" do
      it "adds an error" do
        described_class.new(:age, "bar", {}, errors).validate
        expect(errors[:age]).to eq("must be a number")
      end
    end

    context "when required is true and value is nil" do
      it "adds an error" do
        described_class.new(:age, nil, { required: true }, errors).validate
        expect(errors[:age]).to eq("is required")
      end
    end

    context "when value is less than the min" do
      it "adds an error" do
        described_class.new(:age, 17, { min: 18 }, errors).validate
        expect(errors[:age]).to eq("must be at least 18")
      end
    end

    context "when value is greater than the max" do
      it "adds an error" do
        described_class.new(:age, 101, { max: 100 }, errors).validate
        expect(errors[:age]).to eq("must be at most 100")
      end
    end

    context "when value is not an integer" do
      it "adds an error" do
        described_class.new(:age, 17.5, { integer: true }, errors).validate
        expect(errors[:age]).to eq("must be an integer")
      end
    end

    context "when value is not a float" do
      it "adds an error" do
        described_class.new(:age, 17, { float: true }, errors).validate
        expect(errors[:age]).to eq("must be a float")
      end
    end

    context "when value is not positive" do
      it "adds an error" do
        described_class.new(:age, 0, { positive: true }, errors).validate
        expect(errors[:age]).to eq("must be positive")
      end
    end

    context "when value is not negative" do
      it "adds an error" do
        described_class.new(:age, 0, { negative: true }, errors).validate
        expect(errors[:age]).to eq("must be negative")
      end
    end

    context "when value is not greater than the gt value" do
      it "adds an error" do
        described_class.new(:age, 0, { gt: 0 }, errors).validate
        expect(errors[:age]).to eq("must be greater than 0")
      end
    end

    context "when value is not greater than or equal to the gte value" do
      it "adds an error" do
        described_class.new(:age, 0, { gte: 1 }, errors).validate
        expect(errors[:age]).to eq("must be greater than or equal to 1")
      end
    end

    context "when value is not less than the lt value" do
      it "adds an error" do
        described_class.new(:age, 1, { lt: 1 }, errors).validate
        expect(errors[:age]).to eq("must be less than 1")
      end
    end

    context "when value is not less than or equal to the lte value" do
      it "adds an error" do
        described_class.new(:age, 1, { lte: 0 }, errors).validate
        expect(errors[:age]).to eq("must be less than or equal to 0")
      end
    end

    context "when value is not equal to the eq value" do
      it "adds an error" do
        described_class.new(:age, 1, { eq: 0 }, errors).validate
        expect(errors[:age]).to eq("must be equal to 0")
      end
    end

    context "when value does not have the correct precision" do
      it "adds an error" do
        described_class.new(:age, 1.234, { precision: 2 }, errors).validate
        expect(errors[:age]).to eq("must have 2 decimal places")
      end
    end

    context "when a custom message is provided" do
      it "uses the custom message" do
        described_class.new(:age, "bar", { message: "custom message" }, errors).validate
        expect(errors[:age]).to eq("custom message")
      end
    end
  end

  describe "#validate positive cases" do
    context "when value is a valid number" do
      it "does not add an error" do
        described_class.new(:age, 18, {}, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is at least the min" do
      it "does not add an error" do
        described_class.new(:age, 18, { min: 18 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is at most the max" do
      it "does not add an error" do
        described_class.new(:age, 100, { max: 100 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is an integer" do
      it "does not add an error" do
        described_class.new(:age, 18, { integer: true }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is a float" do
      it "does not add an error" do
        described_class.new(:age, 17.5, { float: true }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is positive" do
      it "does not add an error" do
        described_class.new(:age, 1, { positive: true }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is negative" do
      it "does not add an error" do
        described_class.new(:age, -1, { negative: true }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is greater than the gt value" do
      it "does not add an error" do
        described_class.new(:age, 1, { gt: 0 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is greater than or equal to the gte value" do
      it "does not add an error" do
        described_class.new(:age, 1, { gte: 1 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is less than the lt value" do
      it "does not add an error" do
        described_class.new(:age, 0, { lt: 1 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is less than or equal to the lte value" do
      it "does not add an error" do
        described_class.new(:age, 0, { lte: 0 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is equal to the eq value" do
      it "does not add an error" do
        described_class.new(:age, 0, { eq: 0 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value has the correct precision" do
      it "does not add an error" do
        described_class.new(:age, 1.23, { precision: 2 }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is nil" do
      it "does not add an error" do
        described_class.new(:age, nil, {}, errors).validate
        expect(errors).to be_empty
      end
    end
  end
end
