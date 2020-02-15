# frozen_string_literal: true

require 'bundler'
Bundler.require

require_all 'lib'

application_params = YAML.safe_load(File.read('config/application.yml'))
ENV['affiliate_id'] = application_params['affiliate_id'] || nil
