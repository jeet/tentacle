module Spec
  module Rails
    module VERSION #:nodoc:
      BUILD_TIME_UTC = 20080309210001
    end
  end
end

# What a bunch of crap.  I installed them on the same f'ing day.
# Verify that the plugin has the same revision as RSpec
# if Spec::Rails::VERSION::BUILD_TIME_UTC != Spec::VERSION::BUILD_TIME_UTC
#   raise <<-EOF
# 
# ############################################################################
# Your RSpec on Rails plugin is incompatible with your installed RSpec.
# 
# RSpec          : #{Spec::VERSION::BUILD_TIME_UTC}
# RSpec on Rails : #{Spec::Rails::VERSION::BUILD_TIME_UTC}
# 
# Make sure your RSpec on Rails plugin is compatible with your RSpec gem.
# See http://rspec.rubyforge.org/documentation/rails/install.html for details.
# ############################################################################
# EOF
# end
