# frozen_string_literal: true

# app/modules/load_balancer.rb
module LoadBalancer
  extend self

  @@counter = 0

  def next_server
    server = servers[counter % servers.length]
    @@counter += 1
    server
  end

  private

  def servers
    @servers ||= Server.all.to_a
  end

  def counter
    @@counter
  end
end


