# frozen_string_literal: true

require 'el_tiempo'
require 'webmock/rspec'

describe ElTiempo do
  describe 'calc' do
    let(:numeric_affiliate_id) { 123 }
    let(:invalid_affiliate_id) { 'invalid_id' }
    let(:affiliate_id) { 'valid_id' }
    let(:location_id) { 102 }

    before :each do
      stub_request(:get, "http://api.tiempo.com/index.php?affiliate_id=#{affiliate_id}&api_lang=es&division=102")
        .to_return(body: locations_body, status: 200,
                   headers: { 'Content-Length' => 3 })

      stub_request(:get, "http://api.tiempo.com/index.php?affiliate_id=#{affiliate_id}&api_lang=es&localidad=79402")
        .to_return(body: location_body, status: 200,
                   headers: { 'Content-Length' => 3 })

      stub_request(:get, "http://api.tiempo.com/index.php?affiliate_id=#{numeric_affiliate_id}&api_lang=es&division=102")
        .to_return(body: affiliate_error_body, status: 200,
                   headers: { 'Content-Length' => 3 })

      stub_request(:get, "http://api.tiempo.com/index.php?affiliate_id=#{invalid_affiliate_id}&api_lang=es&division=102")
        .to_return(body: affiliate_error_body, status: 200,
                   headers: { 'Content-Length' => 3 })
    end

    context 'give wrong params' do
      it 'Less than two params' do
        expected_message = 'Error. Less than two params'
        expect(ElTiempo.calc(['-today'], affiliate_id, location_id)).to eq(expected_message)
        expect(ElTiempo.calc(['Gavá'], affiliate_id, location_id)).to eq(expected_message)
      end

      it 'More than two params' do
        expect(ElTiempo.calc(['-today', 'Gavá', '-today'], affiliate_id, location_id)).to eq('Error. More than two params')
      end

      it 'Wrong option' do
        expect(ElTiempo.calc(['-wrong', 'Gavá'], affiliate_id, location_id)).to eq('Error. Wrong option chosen (today, av_min, av_max)')
      end

      it 'Wrong city name' do
        expect(ElTiempo.calc(['-today', 'no city name'], affiliate_id, location_id)).to eq('Error. City not found')
      end

      it 'Missing affiliate_id' do
        expect(ElTiempo.calc(['-today', 'Gavá'])).to eq('Error. Missing affiliate_id')
      end

      it 'Numeric affiliate_id' do
        expect(ElTiempo.calc(['-today', 'Gavá'], numeric_affiliate_id, location_id)).to eq('Error. Wrong affiliate id')
      end

      it 'Invalid affiliate_id' do
        expect(ElTiempo.calc(['-today', 'Gavá'], invalid_affiliate_id, location_id)).to eq('Error. Wrong affiliate id')
      end

      it 'Missing location_id' do
        expect(ElTiempo.calc(['-today', 'Gavá'], invalid_affiliate_id)).to eq('Error. Missing location_id')
      end
    end

    context 'give good params' do

      context 'today' do
        it 'today' do
          expect(ElTiempo.calc(['-today', "la Pineda d'en Feu"], affiliate_id, location_id)).to eq('It\'s 15 degrees')
        end
      end

      context 'av_max' do
        it 'today' do
          expect(ElTiempo.calc(['-av_max', "la Pineda d'en Feu"], affiliate_id, location_id)).to eq('The average of maximums is 17.14')
        end
      end

      context 'av_min' do
        it 'today' do
          expect(ElTiempo.calc(['-av_min', "la Pineda d'en Feu"], affiliate_id, location_id)).to eq('The average of minimums is 6.86')
        end
      end
    end

    def locations_body
      File.open('spec/files/locations_data.xml').read
    end

    def location_body
      File.open('spec/files/location_data.xml').read
    end

    def affiliate_error_body
      File.open('spec/files/error.xml').read
    end
  end
end
