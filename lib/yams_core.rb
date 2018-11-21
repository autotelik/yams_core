require "yams_core/engine"

module YamsCore
  # Your code goes here...
  #

  def self.docker_path
    File.expand_path("#{File.dirname(__FILE__)}/../docker")
  end

  def self.library_path
    File.expand_path("#{File.dirname(__FILE__)}/../lib")
  end

  def self.root_path
    File.expand_path("#{File.dirname(__FILE__)}/..")
  end


end
