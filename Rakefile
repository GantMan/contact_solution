# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'
require './lib/contact_solution'

begin
  require 'bundler'
  require 'motion/project/template/gem/gem_tasks'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ContactSolution Example'
  app.package = "com.gantman.contact_solution"
  app.api_version = "16"
  app.permissions += [:read_contacts]

  app.application_class = "ContactSolutionApplication"
  app.main_activity = "PMHomeActivity"
  app.sub_activities += %w(PMSingleFragmentActivity PMNavigationActivity)

  app.archs = ["x86"] unless ARGV.include?("device") || ARGV.include?("release")

  app.gradle do
    # Google's networking API for Android
    dependency "com.mcxiaoke.volley", :artifact => "library", :version => "1.0.10"

    # support lib
    dependency "com.android.support", artifact: "support-v4", version: "18.0.+"

    # Google's Android Play Services
    #dependency 'com.android.support', :artifact => 'appcompat-v7', :version => '21.0.3'
    #dependency "com.google.android.gms", :artifact => "play-services-maps", :version => "7.3.0"
  end

end
