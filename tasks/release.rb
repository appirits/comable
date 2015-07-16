# refs: https://github.com/rails/rails/blob/4-1-stable/tasks/release.rb

FRAMEWORKS = %w( core frontend backend sample )

root    = File.expand_path('../../', __FILE__)
version = File.read("#{root}/COMABLE_VERSION").strip
tag     = "v#{version}"

directory 'pkg'

(FRAMEWORKS + ['comable']).each do |framework|
  namespace framework do
    gemname = (framework == 'comable') ? framework : "comable-#{framework}"
    gem     = "pkg/#{gemname}-#{version}.gem"
    gemspec = "#{gemname}.gemspec"

    task :clean do
      rm_f gem
    end

    task gem => :pkg do
      cmd = ''
      cmd << "cd #{framework} && " unless framework == 'comable'
      cmd << "gem build #{gemspec} && mv #{gemname}-#{version}.gem #{root}/pkg/"
      sh cmd
    end

    task :build => [:clean, gem]
    task :install => :build do
      sh "gem install #{gem}"
    end

    task :prep_release => [:ensure_clean_state, :build]

    task :push => :build do
      sh "gem push #{gem}"
    end
  end
end

namespace :changelog do
  task :release_date do
    FRAMEWORKS.each do |fw|
      require 'date'
      replace = '\1(' + Date.today.strftime('%B %d, %Y') + ')'
      fname = File.join fw, 'CHANGELOG.md'

      contents = File.read(fname).sub(/^([^(]*)\(unreleased\)/, replace)
      File.open(fname, 'wb') { |f| f.write contents }
    end
  end

  task :release_summary do
    FRAMEWORKS.each do |fw|
      puts "## #{fw}"
      fname    = File.join fw, 'CHANGELOG.md'
      contents = File.readlines fname
      contents.shift
      changes = []
      changes << contents.shift until contents.first =~ /^\## Comable \d+\.\d+\.\d+/
      puts changes.reject { |change| change.strip.empty? }.join
      puts
    end
  end
end

namespace :all do
  task :build           => (FRAMEWORKS + ['comable']).map { |f| "#{f}:build"           }
  task :update_versions => (FRAMEWORKS + ['comable']).map { |f| "#{f}:update_versions" }
  task :install         => (FRAMEWORKS + ['comable']).map { |f| "#{f}:install"         }
  task :push            => (FRAMEWORKS + ['comable']).map { |f| "#{f}:push"            }

  task :ensure_clean_state do
    unless `git status -s | grep -v COMABLE_VERSION`.strip.empty?
      abort '[ABORTING] `git status` reports a dirty tree. Make sure all changes are committed'
    end

    unless ENV['SKIP_TAG'] || `git tag | grep '^#{tag}$`.strip.empty?
      abort "[ABORTING] `git tag` shows that #{tag} already exists. Has this version already\n"\
            '           been released? Git tagging can be skipped by setting SKIP_TAG=1'
    end
  end

  task :commit do
    File.open('pkg/commit_message.txt', 'w') do |f|
      f.puts "# Preparing for #{version} release\n"
      f.puts
      f.puts '# UNCOMMENT THE LINE ABOVE TO APPROVE THIS COMMIT'
    end

    sh 'git add . && git commit --verbose --template=pkg/commit_message.txt'
    rm_f 'pkg/commit_message.txt'
  end

  task :tag do
    sh "git tag -m '#{tag} release' #{tag}"
    sh 'git push --tags'
  end

  task :release => %w(ensure_clean_state build commit tag push)
end
