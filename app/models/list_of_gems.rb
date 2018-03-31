class ListOfGems
  require 'bundler'

  attr_reader :gems, :columns_gems

  def initialize(params = {})
    @gems = []
    specs = Bundler.load.specs
    specs.each do |spec|
      @gems << "#{spec.name.downcase} #{spec.version}"
    end
    @gems.sort! { |gem_a, gem_b| gem_a <=> gem_b }

    if params[:columns]
      cnt = (@gems.length / params[:columns]).to_i + 1
      @columns_gems = @gems.in_groups_of(cnt, false)
    else
      @columns_gems = Array.new(@gems)
    end
  end

  def select_gem(regex)
    gems.find { |name| name =~ regex }
  end
end
