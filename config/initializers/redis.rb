# REDIS_CONFIG = YAML.load(File.open(Rails.root.join('config/redis.yml'))).symbolize_keys
# default_config = REDIS_CONFIG[:default].symbolize_keys
# redis_config = default_config.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys) if REDIS_CONFIG[Rails.env.to_sym]

# $redis = Redis.new(redis_config)
# # @see https://github.com/resque/redis-namespace
# $namespaced_redis = Redis::Namespace.new(redis_config[:namespace], redis: $redis) if redis_config[:namespace]

# # redis -> object
# # @see https://github.com/nateware/redis-objects
# # require 'connection_pool'
# # Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { $redis }

# # To clear out the db before each test and development
# begin
#   $redis.flushdb if Rails.env == 'test'
#   # $redis.flushdb if Rails.env == 'development'
# rescue Exception => e
#   p '-' * 20
#   p "Error trying with $redis.flushdb: #{e.message}"
#   p 'You may need to start the redis-server with `sudo service redis-server start`'
#   p 'If the redis-server is not installed, please `sudo apt-get install redis-server`.'
#   p 'You are not using linux? See you.'
#   p '-' * 20
#   rails_pid = Process.pid
#   cmd = "kill -SIGINT #{rails_pid}"
#   `#{cmd}`
# end