require 'thor'
require 'kamehameha/cookbook'

module Kamehameha
  class CLI < Thor
    package_name 'kamehameha'
    desc 'exec', ''
    def exec(path)
      cb = Cookbook.new
      cb.destination_root = './'
      cb.invoke_all
    end
  end
end