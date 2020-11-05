require 'google/apis/sheets_v4'
require 'json'
require 'dotenv/load'

TOPICS_SHEET_NAME = 'Thématiques'
TOPICS_SHEET_RANGE = 'A:C'
TOPICS_SHEET_START_ROW = 4

INVENTORY_SHEET_NAME = 'Inventaire'
INVENTORY_SHEET_RANGE = 'A:E'
INVENTORY_SHEET_START_ROW = 4

service = Google::Apis::SheetsV4::SheetsService.new
service.key = ENV['GOOGLE_SHEETS_API_KEY']
spreadsheet_id = ENV['GOOGLE_SPREADSHEET_ID']

range = "'#{TOPICS_SHEET_NAME}'!#{TOPICS_SHEET_RANGE}"
response = service.get_spreadsheet_values spreadsheet_id, range

# TODO : handle error if response is empty
topics = {}

response.values.each_with_index do |row, i|
  next if i < TOPICS_SHEET_START_ROW

  topics[row[0]] = {
    label: row[0],
    color: row[1],
    keywords: row[2].split(','),
  }
end

topics_file = File.join(
  File.dirname(__FILE__),
  './../src/topics.json'
)
File.write(topics_file, JSON.dump(topics))

range = "'#{INVENTORY_SHEET_NAME}'!#{INVENTORY_SHEET_RANGE}"
response = service.get_spreadsheet_values spreadsheet_id, range

inventory = []
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

inventory_file = File.join(
  File.dirname(__FILE__),
  './../src/inventory.json'
)
File.write(inventory_file, JSON.dump(inventory))
