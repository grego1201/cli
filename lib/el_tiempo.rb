class ElTiempo

  def self.calc(options)
    error = check_valid_options(options)
    return error unless error.empty?
  end

  def self.check_valid_options(options)
    return 'Less than two params' if options.count < 2
    return 'More than two params' if options.count > 2

    unless %w[-today -av_min -av_max].include?(options.first)
      return 'Wrong option chosen (today, av_min, av_max)'
    end

    ''
  end
end
