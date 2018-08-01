require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JieZhang
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # config.autoload_paths += %W(#{config.root}/lib)
    
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    
    config.autoload_paths += [
      Rails.root.join("lib")
    ]
    config.eager_load_paths += [
      Rails.root.join("lib/jiezhang")
    ]
  end
  
  class Logger < ::Logger
    def self.error(message)
      build.error(message)
    end
  
    def self.info(message)
      build.info(message)
    end
  
    def self.build
      new(Rails.root.join("log/application.log"))
    end
  end
  
end
