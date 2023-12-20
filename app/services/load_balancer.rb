# frozen_string_literal: true
require 'redis'

# The LoadBalancer module provides a round-robin mechanism for distributing requests
# among a list of servers. It uses Redis for caching server information and synchronizes
# access to shared resources using a mutex.
module LoadBalancer
  extend self

  # The Redis key for storing the list of servers
  CACHE_KEY = 'load_balancer:servers'

  # The Redis key for storing the current server index
  INDEX_KEY = 'load_balancer:current_index'

  # The maximum number of retries in case of errors when fetching the next server
  MAX_RETRIES = 3

  # Mutex for synchronizing access to shared resources
  @@mutex = Mutex.new

  # Redis instance shared across all instances of the LoadBalancer module
  @@redis = Redis.new

  # Initializes the list of servers either from cache or the database
  def initialize_servers
    @servers = fetch_servers_from_cache || Server.all.to_a
  end

  # Retrieves the next server using a round-robin mechanism
  def next_server
    initialize_servers
    retry_count = 0

    begin
      @@mutex.synchronize do
        @current_server_index = fetch_index_from_cache || 0
        server = @servers[@current_server_index]
        @current_server_index = (@current_server_index + 1) % @servers.length
        cache_index
        server
      end
    rescue StandardError => e
      retry_count += 1
      retry if retry_count < MAX_RETRIES
      # Log or handle the exception appropriately
      raise "Error while fetching the next server: #{e.message}"
    end
  end

  private

  # Fetches the list of servers from the Redis cache
  def fetch_servers_from_cache
    cached_servers = @@redis.get(CACHE_KEY)
    return nil unless cached_servers

    JSON.parse(cached_servers, symbolize_names: true)
  rescue JSON::ParserError => e
    # Log or handle JSON parsing errors
    raise "Error while parsing JSON from cache: #{e.message}"
  end

  # Caches the list of servers in the Redis cache
  def cache_servers
    @@redis.set(CACHE_KEY, @servers.to_json)
  rescue StandardError => e
    # Log or handle Redis set errors
    raise "Error while caching servers: #{e.message}"
  end

  # Fetches the current server index from the Redis cache
  def fetch_index_from_cache
    @@redis.get(INDEX_KEY).to_i
  rescue StandardError => e
    # Log or handle Redis get errors
    raise "Error while fetching index from cache: #{e.message}"
  end

  # Caches the current server index in the Redis cache
  def cache_index
    @@redis.set(INDEX_KEY, @current_server_index)
  rescue StandardError => e
    # Log or handle Redis set errors
    raise "Error while caching index: #{e.message}"
  end
end
