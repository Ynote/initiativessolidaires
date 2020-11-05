require 'erb'
require 'json'
require 'dotenv/load'
require_relative './string_monkey_patch.rb'

class Inventory
  attr_reader :inventory
  attr_reader :topics

  def initialize
    inventory_file = File.join(
      File.dirname(__FILE__),
      "./../#{ENV['INVENTORY_FILENAME']}"
    )
    topics_file = File.join(
      File.dirname(__FILE__),
      "./../#{ENV['TOPICS_FILENAME']}"
    )

    @inventory = JSON.parse(File.read(inventory_file)).shuffle
    @topics = JSON.parse(File.read(topics_file))
  end

  def get_binding
    binding
  end
end

def build
  template_file = File.join(
    File.dirname(__FILE__),
    './../src/template.html.erb'
  )
  template = File.read(template_file)

  File.open('dist/index.html', 'w') do |f|
    output = ERB.new(template).result(Inventory.new.get_binding)
    f.write output
  end
end

build
