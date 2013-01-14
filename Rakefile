require "rubygems"
require "bundler"

task :default => [:cookbook_test, :tailor, :foodcritic, :chefspec]

desc "Run knife cookbook syntax test"
task :cookbook_test do
  puts "Running knife cookbook syntax test..."
  puts %x{knife cookbook test -o .. clamav}
  $?.exitstatus == 0 or fail "Cookbook syntax check failed!"
end

desc "Run Tailor lint tests"
task :tailor do
  puts "Running Tailor lint tests..."
  puts %x{tailor `find . -name '*.rb' -and ! -path '*/\.kitchen/*'`}
  $?.exitstatus == 0 or fail "Tailor lint tests failed!"
end

desc "Run Foodcritic lint tests"
task :foodcritic do
  puts "Running FoodCritic lint tests..."
  puts %x{foodcritic -f any .}
  $?.exitstatus == 0 or fail "Foodcritic lint tests failed!"
end

desc "Run ChefSpec unit tests"
task :chefspec do
  puts "Running ChefSpec unit tests..."
  puts %x{rspec}
  $?.exitstatus == 0 or fail "ChefSpec unit tests failed!"
end

desc "Run a full converge test"
task :converge do
  puts "Running Convergence tests..."

  solo_rb = <<-EOH.gsub(/^ +/, "")
    file_cache_path "/tmp"
    cookbook_path [
      "#{File.expand_path("../", __FILE__)}",
      "/tmp/berkshelf"
    ]
    role_path nil
    log_level :info
    encrypted_data_bag_secret "/tmp/encrypted_data_bag_secret"
    http_proxy nil
    http_proxy_user nil
    http_proxy_pass nil
    https_proxy nil
    https_proxy_user nil
    https_proxy_pass nil
    no_proxy_nil
  EOH

  dna_json = <<-EOH.gsub(/^ +/, "")
    {
      "run_list": [
        "recipe[minitest-handler]",
        "recipe[clamav::default]",
        "recipe[clamav::install_deb]",
        "recipe[clamav::users]",
        "recipe[clamav::logging]",
        "recipe[clamav::clamd]",
        "recipe[clamav::freshclam]",
        "recipe[clamav::clamd_service]",
        "recipe[clamav::freshclam_service]"
      ],
      "clamav": {
        "clamd": {
          "enabled": true
        },
        "freshclam": {
          "enabled": true
        }
      }
    }
  EOH

  File.open("/tmp/solo.rb", "w") { |f| f.write(solo_rb) }
  File.open("/tmp/dna.json", "w") { |f| f.write(dna_json) }

  puts %x{bundle exec sudo chef-solo -c /tmp/solo.rb -j /tmp/dna.json}
  $?.exitstatus == 0 or fail "Convergence failed!"

  puts %x{cucumber test/features}
  $?.exitstatus == 0 or fail "Cucumber tests failed!"
end

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
