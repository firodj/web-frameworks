require "spec"
require "http/client"

# Class to memoize spec variables
class Config
  property params = {} of Symbol => (String | Bool | Float64)

  def self.params
    self.instance.params
  end

  def self.instance
    @@instance ||= new
  end
end

def framework
  ENV["FRAMEWORK"]
end

def local_port
  ENV["LOCAL_PORT"]?
end

def cid
  Config.params[:cid]
end

def remote_address
  Config.params[:remote_address]
end

def docker_start
  Config.params[:cid] = if local_port
    `docker run -td -p 127.0.0.1:#{local_port}:3000 #{framework}`.strip
  else
    `docker run -td #{framework}`.strip
  end

  sleep 25

  Config.params[:remote_address] = if local_port
    "127.0.0.1:#{local_port}"
  else
    ip = `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' #{cid}`.strip
    ip + ":3000"
  end
end

def docker_stop
  `docker stop #{cid}`
end

Spec.before_suite {
  docker_start
}

Spec.after_suite {
  docker_stop
}
