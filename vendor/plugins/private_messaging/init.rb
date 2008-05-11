Rails.plugin_routes << :private_messaging

$stderr.puts "init.rb"
Dir["#{File.dirname(__FILE__)}/lib/initializers/*.rb"].each do |f|
  $stderr.puts "Requiring #{f}"
  require f
end

require File.dirname(__FILE__) + "/app/models/profile"
