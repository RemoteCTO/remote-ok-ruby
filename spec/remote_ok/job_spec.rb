# frozen_string_literal: true

RSpec.describe RemoteOK::Job do
  let(:job_data) do
    file = File.open "spec/fixtures/jobs_data.json"
    JSON.parse(file.read).last
  end

  let(:job) do
    described_class.new(job_data)
  end

  it "can instantiate" do
    expect(job).not_to be_nil
  end

  describe "#raw" do
    it "returns the original raw data" do
      expect(job.raw).to eq job_data
    end
  end

  describe "#slug" do
    it "returns the slug field" do
      expect(job.slug).to eq "564738-remote-customer-success-associate"
    end
  end

  describe "#id" do
    it "returns the id as an integer" do
      expect(job.id).to eq 564_738
    end
  end

  describe "#epoch" do
    it "returns the epoch as an integer" do
      expect(job.epoch).to eq 1_619_724_426
    end
  end

  describe "#date" do
    it "returns the date as a date" do
      expect(job.date).to eq DateTime.new(2021, 4, 29, 19, 27, 6, "06+00:00")
    end
  end

  describe "#company" do
    it "returns the company name" do
      expect(job.company).to eq "Distance"
    end
  end

  describe "#company_logo" do
    it "returns the company logo url as a string" do
      expect(job.company_logo).to eq "https://remoteOK.io/assets/jobs/4b011439d2f3d8sa9das0710ff49c21619724426.png"
    end
  end

  describe "#position" do
    it "returns the company position" do
      expect(job.position).to eq "Customer Success Associate"
    end
  end

  describe "#tags" do
    it "returns the array of tags" do
      expect(job.tags).to eq %i[dev dot_net digital_nomad]
    end
  end

  describe "#logo" do
    it "returns url for logo" do
      expect(job.logo).to eq "https://remoteOK.io/assets/jobs/4b011439d2df9s8f0d9sff49c21619724426.png"
    end
  end

  describe "#description" do
    it "returns the raw description" do
      expect(job.description).to start_with "<p><strong>Our Products</strong>"
    end
  end

  describe "#description_text" do
    it "returns the raw description text with no html" do
      substring = "Our Products Our software products involve industrial plant"
      expect(job.description_text).to start_with substring
    end
  end

  describe "#location" do
    it "returns the location string" do
      expect(job.location).to eq "North America"
    end
  end

  describe "#original" do
    it "returns the original flag" do
      expect(job.original).to be true
    end
  end

  describe "#url" do
    it "returns the url string" do
      expect(job.url).to eq "https://remoteOK.io/remote-jobs/564738-remote-customer-success-associate"
    end
  end

  describe "#apply_url" do
    it "returns the apply url string" do
      expect(job.apply_url).to eq "https://remoteOK.io/l/564738"
    end
  end
end
