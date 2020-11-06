require 'erb'
require 'json'
require 'dotenv/load'
require_relative './constants.rb'
require_relative './string_monkey_patch.rb'
require_relative './google_sheets_fetcher.rb'

class Inventory
  attr_reader :inventory
  attr_reader :topics

  def initialize
    inventory_file = File.join(
      File.dirname(__FILE__),
      "./../#{INVENTORY_FILENAME}"
    )
    topics_file = File.join(
      File.dirname(__FILE__),
      "./../#{TOPICS_FILENAME}"
    )

    @inventory = JSON.parse(File.read(inventory_file)).shuffle
    @topics = JSON.parse(File.read(topics_file))
  end

  def self.build
    GoogleSheetsFetcher.new.run

    template_file = File.join(__dir__, './../templates/index.html.erb')
    template = File.read(template_file)

    File.open('dist/index.html', 'w') do |f|
      output = ERB.new(template).result(new.get_binding)
      f.write output
    end
  end

  def get_binding
    binding
  end
end
