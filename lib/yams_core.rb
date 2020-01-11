require "yams_core/engine"

module YamsCore

  # don't prefix table names
  def self.table_name_prefix; end

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

