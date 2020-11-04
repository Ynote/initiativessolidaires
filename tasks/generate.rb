require 'erb'
require 'json'
require_relative './string_monkey_patch.rb'

class Inventory
  INVENTORY_FILENAME = 'inventory.json'
  TOPICS_FILENAME = 'topics.json'

  attr_reader :inventory
  attr_reader :topics

  def initialize
    inventory_file = File.join(
      File.dirname(__FILE__),
      "./../src/#{INVENTORY_FILENAME}"
    )
    topics_file = File.join(
      File.dirname(__FILE__),
      "./../src/#{TOPICS_FILENAME}"
    )

    @inventory = JSON.parse(File.read(inventory_file)).shuffle
    @topics = JSON.parse(File.read(topics_file))
  end

  def get_binding
    binding
  end
end

template_file = File.join(File.dirname(__FILE__), "./../src/template.html.erb")
template = File.read(template_file)

File.open('dist/index.html', 'w') do |f|
  output = ERB.new(template).result(Inventory.new.get_binding)
  f.write output
end
