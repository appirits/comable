seeds_path = File.join(File.dirname(__FILE__), 'seeds')

Dir.glob(File.join(seeds_path, '**/*.rb')).sort.each do |fixture_file|
  require fixture_file
end
