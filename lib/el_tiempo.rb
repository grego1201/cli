# frozen_string_literal: true

require 'json'
require 'net/http'
require 'active_support/core_ext/hash'

class ElTiempo
  BASE_URL = 'http://api.tiempo.com/index.php?api_lang=es'
  LOCATIONS_PARAM = 'division='
  LOCATION_PARAM = 'localidad='
  AFFILIATE_PARAM = 'affiliate_id='

  def self.calc(options = [], affiliate_id = nil, location_id = nil)
    @city = options[1]
    @affiliate_id = affiliate_id
    @location_id = location_id

    error = check_valid_options(options)
    return error unless error.empty?

    city_url = obtain_city_url
    return city_url if city_url.include?('Error.')

    data = obtain_hash_from_url(city_url)
    @city_data = data['report']['location']['var']

    send(options[0][1..-1])
  end

  def self.check_valid_options(options)
    return 'Error. Missing affiliate_id' if @affiliate_id.nil?
    return 'Error. Missing location_id' if @location_id.nil?
    return 'Error. Less than two params' if options.count < 2
    return 'Error. More than two params' if options.count > 2

    unless %w[-today -av_min -av_max].include?(options.first)
      return 'Error. Wrong option chosen (today, av_min, av_max)'
    end

    ''
  end

  def self.today
    today_value = @city_data.select { |var| var['name'] == 'Día' }[0]['icon']

    "It's #{today_value} degrees"
  end

  def self.av_max
    day_values = @city_data.select { |var| var['name'] == 'Temperatura Máxima' }[0]['data']['forecast']
    "The average of maximums is #{obtain_mean(day_values)}"
  end

  def self.av_min
    day_values = @city_data.select { |var| var['name'] == 'Temperatura Mínima' }[0]['data']['forecast']
    "The average of minimums is #{obtain_mean(day_values)}"
  end

  def self.obtain_mean(data)
    values = data.map { |day| day['value'].to_i }
    (values.reduce(:+) / values.size.to_f).round(2)
  end

  def self.obtain_city_url
    data = obtain_hash_from_url(generate_url)
    return 'Error. Wrong affiliate id' if data['report'].keys.include?('error')

    data = data['report']['location']['data']
    city_names = data.map { |city| city['name'] }
    return 'Error. City not found' unless city_names.include?(@city)

    preprocess_url = data.select { |city| city['name'] == @city }[0]['url']
    preprocess_url.concat("&#{AFFILIATE_PARAM}#{@affiliate_id}")
  end

  def self.generate_url
    [BASE_URL, AFFILIATE_PARAM + @affiliate_id.to_s, LOCATIONS_PARAM + @location_id.to_s].join('&')
  end

  def self.obtain_hash_from_url(url)
    request_body = ::Net::HTTP.get_response(URI.parse(url)).body
    Hash.from_xml(request_body)
  end
end
