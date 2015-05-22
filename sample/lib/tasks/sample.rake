namespace :comable do
  desc 'Imports sample data'
  task sample: :environment do
    Comable::Sample.import_all
  end
end
