require 'spec_helper'

RSpec.describe Inventory do
  subject { described_class.new }
  let(:inventory) do
    instance_double(Inventory, get_binding: 'binding')
  end
  let(:google_fetcher) { instance_double(GoogleSheetsFetcher, run: nil) }
  let(:erb) { instance_double(ERB, result: 'Alice in Wonderland' )}
  let(:list) do
    ['Mad Hatter', 'Cheshire Cat', 'Queen of Hearts'].to_json
  end
  let(:array) { instance_double(Array) }

  describe '.build' do
    before do
      allow(GoogleSheetsFetcher)
        .to receive(:new)
        .and_return(google_fetcher, google_fetcher)

      allow(ERB)
        .to receive(:new)
        .with('Alice')
        .and_return(erb)

      allow(described_class)
        .to receive(:new)
        .and_return(inventory)

      allow(File).to receive(:join)
      allow(File).to receive(:read).and_return('Alice')
      allow(File).to receive(:write)

      Inventory.build
    end

    it 'fetched Google Sheets data' do
      expect(google_fetcher).to have_received(:run)
    end

    it 'uses the index template' do
      expect(File)
        .to have_received(:join)
        .with(/src\/lib/, /templates\/index.html.erb/)
    end

    it 'passes the class context to the template' do
      expect(erb).to have_received(:result).with('binding')
    end

    it 'creates an HTML file' do
      expect(File)
        .to have_received(:write)
        .with('dist/index.html', 'Alice in Wonderland')
    end
  end

  describe '#inventory' do
    before do
      allow(File).to receive(:join)
      allow(File).to receive(:read).and_return(list)
    end

    it 'uses the inventory JSON file' do
      subject.inventory

      expect(File)
        .to have_received(:join)
        .with(/src\/lib/, /inventory.json/)
    end

    it 'shuffles the content of the list' do
      allow(JSON).to receive(:parse).and_return(array)
      allow(array).to receive(:shuffle)

      subject.inventory

      expect(array).to have_received(:shuffle)
    end
  end

  describe '#topics' do
    before do
      allow(File).to receive(:join)
      allow(File).to receive(:read).and_return(list)

      subject.topics
    end

    it 'uses the topics JSON file' do
      expect(File)
        .to have_received(:join)
        .with(/src\/lib/, /topics.json/)
      expect(File).to have_received(:read)
    end
  end
end
