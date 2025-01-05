RSpec.describe Validatron::Validators::DateValidator do
  let(:errors) { {} }

  describe "#validate negative cases" do
    context "when value is not a date" do
      it "adds an error" do
        described_class.new(:dob, "bar", {}, errors).validate
        expect(errors[:dob]).to eq("must be a valid date")
      end
    end

    context "when value is not a valid date" do
      it "adds an error" do
        described_class.new(:dob, "2020-02-100", {}, errors).validate
        expect(errors[:dob]).to eq("must be a valid date")
      end
    end

    context "when value is not in ISO 8601 format" do
      it "adds an error" do
        described_class.new(:dob, "2020-02-10", { iso: true }, errors).validate
        expect(errors[:dob]).to eq("must be in ISO 8601 format")
      end
    end

    context "when value is before the min date" do
      it "adds an error" do
        described_class.new(:dob, "2019-12-31", { min: "2020-01-01" }, errors).validate
        expect(errors[:dob]).to eq("must be on or after 2020-01-01")
      end
    end

    context "when value is after the max date" do
      it "adds an error" do
        described_class.new(:dob, "2020-12-31", { max: "2020-12-30" }, errors).validate
        expect(errors[:dob]).to eq("must be on or before 2020-12-30")
      end
    end

    context "when value is not a timestamp" do
      it "adds an error" do
        described_class.new(:dob, "2020-12-31", { timestamp: true }, errors).validate
        expect(errors[:dob]).to eq("must be a valid timestamp")
      end
    end

    context "when a custom message is provided" do
      it "uses the custom message" do
        described_class.new(:dob, "bar", { message: "custom message" }, errors).validate
        expect(errors[:dob]).to eq("custom message")
      end
    end
  end

  describe "#validate positive cases" do
    context "when value is a date" do
      it "does not add an error" do
        described_class.new(:dob, "2020-02-10", {}, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is a valid date" do
      it "does not add an error" do
        described_class.new(:dob, "2020-02-10", {}, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is in ISO 8601 format" do
      it "does not add an error" do
        described_class.new(:dob, "2020-02-10T10:00:00Z", { iso: true }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is on or after the min date" do
      it "does not add an error" do
        described_class.new(:dob, "2020-01-01", { min: "2020-01-01" }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is on or before the max date" do
      it "does not add an error" do
        described_class.new(:dob, "2020-12-30", { max: "2020-12-30" }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is a timestamp" do
      it "does not add an error" do
        described_class.new(:dob, Time.now, { timestamp: true }, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is a date object" do
      it "does not add an error" do
        described_class.new(:dob, Date.today, {}, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is a time object" do
      it "does not add an error" do
        described_class.new(:dob, Time.now, {}, errors).validate
        expect(errors).to be_empty
      end
    end

    context "when value is a string" do
      it "does not add an error" do
        described_class.new(:dob, "2020-02-10", {}, errors).validate
        expect(errors).to be_empty
      end
    end
  end
end
