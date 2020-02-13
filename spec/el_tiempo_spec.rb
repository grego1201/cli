# frozen_string_literal: true

require 'el_tiempo'

describe ElTiempo do
  describe 'calc' do
    context 'give wrong params' do
      it 'Less than two params' do
        expected_message = 'Less than two params'
        expect(ElTiempo.calc(['-today'])).to eq(expected_message)
        expect(ElTiempo.calc(['Gavá'])).to eq(expected_message)
      end

      it 'More than two params' do
        expect(ElTiempo.calc(['-today', 'Gavá', '-today'])).to eq('More than two params')
      end

      it 'Wrong option' do
        expect(ElTiempo.calc(['-wrong', 'Gavá'])).to eq('Wrong option chosen (today, av_min, av_max)')
      end
    end

    context 'give good params' do
    end
  end
end
