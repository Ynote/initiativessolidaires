class GoogleSheetsFetcher
  TOPICS_SHEET_NAME = 'Thématiques'.freeze
  TOPICS_SHEET_RANGE = 'A:C'.freeze
  TOPICS_SHEET_START_ROW = 4.freeze

  INVENTORY_SHEET_NAME = 'Inventaire'.freeze
  INVENTORY_SHEET_RANGE = 'A:E'.freeze
  INVENTORY_SHEET_START_ROW = 4.freeze

  attr_reader :topics, :inventory

  def initialize
    @topics = {}
    @inventory = []
  end

  def run
    fetch_topics
    fetch_inventory
  end

  private

  def fetch_topics
    response = service.get_spreadsheet_values(
      spreadsheet_id,
      topics_range
    )

    raise "Empty response" if response.values.empty?

    response.values.each_with_index do |row, i|
      next if i < TOPICS_SHEET_START_ROW

      topics[row[0]] = {
        label: row[0],
        color: row[1],
        keywords: row[2].split(',').map(&:strip),
      }
    end

    File.write(topics_file, JSON.dump(topics))
  end

  def fetch_inventory
    response = service.get_spreadsheet_values(
      spreadsheet_id,
      inventory_range
    )

    current_topic = ''

    response.values.each_with_index do |row, i|
      next if i < INVENTORY_SHEET_START_ROW

      if topics.keys.include?(row[0])
        current_topic = row[0]
        next
      end

      inventory.push({
        organization: row[0],
        mission: row[1],
        localization: row[2],
        website: row[3],
        contact: row[4],
        keywords: current_topic,
      })
    end

    File.write(inventory_file, JSON.dump(inventory))
  end

  def service
    @service ||= begin
      service = Google::Apis::SheetsV4::SheetsService.new
      service.key = api_key
      service
    end
  end

  def topics_range
    "'#{TOPICS_SHEET_NAME}'!#{TOPICS_SHEET_RANGE}"
  end

  def topics_file
    File.join(File.dirname(__FILE__), "./../#{TOPICS_FILENAME}")
  end

  def inventory_range
    "'#{INVENTORY_SHEET_NAME}'!#{INVENTORY_SHEET_RANGE}"
  end

  def inventory_file
    File.join(File.dirname(__FILE__), "./../#{INVENTORY_FILENAME}")
  end

  def spreadsheet_id
    ENV['GOOGLE_SPREADSHEET_ID']
  end

  def api_key
    ENV['GOOGLE_SHEETS_API_KEY']
  end
end
