require 'yaml'
require 'fileutils'

module Kamehameha
  class Cookbook < Thor::Group
    include Thor::Actions
    
    class_option :path, :default => './data.yml'
    class_option :install_hab, :default => 'false'
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_metadata
      boilerplate = {
        'metadata.rb' => 'cookbook/metadata.rb',
        'Berksfile' => 'cookbook/Berksfile'
      }
      boilerplate.each do |src, dst|
        destination = File.join(Dir.pwd, dst)
        copy_file("cookbook/#{src}", destination)
      end
    end

    def load_attributes
      @attrs = YAML.load_file(options[:path])
    end

    def copy_toml
      @attrs['hosts'].each do |host|
        next if host['user_toml'].nil?
        basename = File.basename(host['user_toml'])
        destination = File.join(Dir.pwd, "cookbook/files/#{basename}")
        FileUtils.mkdir_p(File.dirname(destination))
        FileUtils.cp(host['user_toml'], destination)
      end
    end

    def generate
      templates = {
        'attributes/default.rb.tt' => 'cookbook/attributes/default.rb',
        'recipes/default.rb.tt' => 'cookbook/recipes/default.rb'
      }
      templates.each do |src, dst|
        destination = File.join(Dir.pwd, dst)
        template("cookbook/#{src}", destination, @attrs, {:force => true})
      end
    end
  end
end
