require 'spec_helper'

RSpec.describe GoogleSheetsFetcher do
  let(:fetcher) { described_class.new }
  let(:service) do
    instance_double(Google::Apis::SheetsV4::SheetsService)
  end
  let(:topics_response) { double(:topics_response, values: topics_values) }
  let(:topics_values) do
    [
      [], [], [], [],
      [
        "Teatime with the Mad Hatter",
        "#fcf5e3",
        "tea, biscuit, party"
      ],
      [
        "Madness in Wonderland",
        "#f9eadb",
        "madness, happy"
      ],
      [
        "Playing with cards",
        "#f4e4e1",
        "cards, royalty, time"
      ],
    ]
  end

  let(:inventory_response) do
    double(:inventory_response, values: inventory_values)
  end
  let(:inventory_values) do
    [
      [], [], [], [],
      ["Teatime with the Mad Hatter"],
      [
        "Mad Hatter",
        "Yes, that's it! Said the Hatter with a sigh, it's always tea time.",
        "Wonderland",
        "https://wonder.land",
        "hello@wonder.land",
      ],
      [
        "Alice",
        "Have i gone mad? I'm afraid so, but let me tell you something, the best people usually are.",
        "Wonderland",
        "https://wonder.land",
        "hello@wonder.land",
      ],
    ]
  end
  let(:topics) do
    {
      "Teatime with the Mad Hatter" => {
        "label": "Teatime with the Mad Hatter",
        "color": "#fcf5e3",
        "keywords": ["tea", "biscuit", "party"]
      },
      "Madness in Wonderland" => {
        "label": "Madness in Wonderland",
        "color": "#f9eadb",
        "keywords": ["madness", "happy"]
      },
      "Playing with cards" => {
        "label": "Playing with cards",
        "color": "#f4e4e1",
        "keywords": ["cards", "royalty", "time"]
      }
    }
  end

  let(:inventory) {
    [
      {
        "organization": "Mad Hatter",
        "mission": "Yes, that's it! Said the Hatter with a sigh, it's always tea time.",
        "localization": "Wonderland",
        "website": "https://wonder.land",
        "contact": "hello@wonder.land",
        "keywords": "Teatime with the Mad Hatter"
      },
      {
        "organization": "Alice",
        "mission": "Have i gone mad? I'm afraid so, but let me tell you something, the best people usually are.",
        "localization": "Wonderland",
        "website": "https://wonder.land",
        "contact": "hello@wonder.land",
        "keywords": "Teatime with the Mad Hatter"
      },
    ]
  }

  describe '#topics' do
    it { expect(fetcher.topics).to eq({}) }
  end

  describe '#inventory' do
    it { expect(fetcher.inventory).to eq([]) }
  end

  describe '#run' do
    before do
      allow_any_instance_of(Google::Apis::SheetsV4::SheetsService)
        .to receive(:get_spreadsheet_values)
        .and_return(topics_response, inventory_response)

      allow(File).to receive(:write)

      fetcher.run
    end


    it 'creates the topics JSON file' do
      expect(File).to have_received(:write)
        .with(/topics\.json/, topics.to_json)
    end

    it 'creates the inventory JSON file' do
      expect(File).to have_received(:write)
        .with(/inventory\.json/, inventory.to_json)
    end
  end
end
