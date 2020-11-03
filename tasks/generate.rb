require 'erb'
require 'json'
require_relative './string_monkey_patch.rb'


class Inventory
  FILENAME = 'inventory.json'

  attr_reader :inventory

  def initialize
    inventory_file = File.join(File.dirname(__FILE__), "./../#{FILENAME}")
    @inventory = JSON.parse(File.read(inventory_file))
  end

  def get_binding
    binding
  end
end

template_file = File.join(File.dirname(__FILE__), "./../template.html.erb")
template = File.read(template_file)

File.open('dist/index.html', 'w') do |f|
  output = ERB.new(template).result(Inventory.new().get_binding)
  f.write output
end
