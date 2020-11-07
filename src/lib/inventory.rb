class Inventory
  def self.build
    GoogleSheetsFetcher.new.run

    template_file = File.join(__dir__, './../templates/index.html.erb')
    template = File.read(template_file)
    output = ERB.new(template).result(new.get_binding)

    File.write('dist/index.html', output)
  end

  def topics
    @topics ||= begin
      topics_file = File.join(__dir__, "./../#{TOPICS_FILENAME}")

      JSON.parse(File.read(topics_file))
    end
  end

  def inventory
    @inventory ||= begin
      inventory_file = File.join(__dir__, "./../#{INVENTORY_FILENAME}")

      JSON.parse(File.read(inventory_file)).shuffle
    end
  end

  def get_binding
    binding
  end
end
