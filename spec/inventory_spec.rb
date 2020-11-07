require 'spec_helper'

RSpec.describe Inventory do
  subject { described_class.new }
  let(:google_fetcher) { instance_double(GoogleSheetsFetcher, run: nil) }
  let(:topics) do
    {
      "Teatime" => {
        "label" => "Teatime with the Mad Hatter",
        "color" => "#fcf5e3",
        "keywords" => ["tea", "biscuit", "party"]
      },
      "Madness" => {
        "label" => "Madness in Wonderland",
        "color" => "#f9eadb",
        "keywords" => ["madness", "happy"]
      },
      "Cards" => {
        "label" => "Playing with cards",
        "color" => "#f4e4e1",
        "keywords" => ["cards", "royalty", "time"]
      }
    }
  end

  let(:inventory) do
    [
      {
        "organization" => "Mad Hatter",
        "mission" => "Yes, that's it! Said the Hatter with a sigh, it's always tea time.",
        "localization" => "Wonderland",
        "website" => "https://wonder.land",
        "contact" => "hello@wonder.land",
        "keywords" => "Teatime"
      },
      {
        "organization" => "Alice",
        "mission" => "Have i gone mad? I'm afraid so, but let me tell you something, the best people usually are.",
        "localization" => "Wonderland",
        "website" => "https://wonder.land",
        "contact" => "hello@wonder.land",
        "keywords" => "Madness"
      },
    ]
  end

  describe '.build' do
    before do
      allow(GoogleSheetsFetcher)
        .to receive(:new)
        .and_return(google_fetcher, google_fetcher)
    end

    describe 'by default' do
      before do
        allow(File).to receive(:join)
        allow(File).to receive(:read).and_return('Alice')

        Inventory.build
      end

      it 'fetched Google Sheets data' do
        expect(google_fetcher).to have_received(:run)
      end

      it 'uses the index template' do
        expect(File)
          .to have_received(:join)
          .with(/src\/lib/, /templates\/index.html.erb/)

        expect(File).to have_received(:read)
      end
    end

    describe 'ERB templating' do
      before do
        allow(File).to receive(:write)
        allow_any_instance_of(described_class)
          .to receive(:topics)
          .and_return(topics)
        allow_any_instance_of(described_class)
          .to receive(:inventory)
          .and_return(inventory)

        Inventory.build
      end

      it 'creates an HTML file' do
        expect(File)
          .to have_received(:write)
          .with('dist/index.html', /<html/)
      end

      it 'creates an HTML file with some options' do
        expect(File)
          .to have_received(:write)
          .with(
            'dist/index.html',
            /<option value="Madness">Madness in Wonderland<\/option>/
          )
      end
    end
  end

  describe '#inventory' do
    before do
      allow(File).to receive(:join)
      allow(File).to receive(:read).and_return(inventory.to_json)
    end

    it 'uses the inventory JSON file' do
      subject.inventory

      expect(File)
        .to have_received(:join)
        .with(/src\/lib/, /inventory.json/)

      expect(File).to have_received(:read)
    end

    it 'shuffles the content of the list' do
      allow(JSON).to receive(:parse).and_return(inventory)
      allow(inventory).to receive(:shuffle)

      subject.inventory

      expect(inventory).to have_received(:shuffle)
    end
  end

  describe '#topics' do
    before do
      allow(File).to receive(:join)
      allow(File).to receive(:read).and_return(topics.to_json)

      subject.topics
    end

    it 'uses the topics JSON file' do
      expect(File)
        .to have_received(:join)
        .with(/src\/lib/, /topics.json/)

      expect(File).to have_received(:read)
    end
  end

  describe '#extract_link' do
    contacts_and_expected_links = {
      'https://example.com' => 'https://example.com',
      'alice@wonder.land' => 'mailto:alice@wonder.land',
      '@cheshire' => 'https://www.instagram.com/cheshire/',
      'insta : cheshire' => 'https://www.instagram.com/cheshire/',
      'send a message to @cheshire' => 'https://www.instagram.com/cheshire/',
      'wonderland' => nil,
      '' => nil,
      nil => nil,
    }
    contacts_and_expected_links.each do |contact, expected_link|
      it "turns #{contact.inspect} into #{expected_link.inspect}" do
        expect(subject.extract_link(contact)).to eq(expected_link)
      end
    end
  end
end
