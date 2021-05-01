class Meeting

  attr_reader :name, :duration, :type
  attr_accessor :start_time

  def initialize(params = {})
    @name = params[:name]
    @duration = params[:duration]
    @type = params[:type]
    @start_time = params[:start_time]
    @end_time = end_time
  end

  def end_time
    return if start_time.nil?

    @end_time = start_time + duration_in_seconds(duration)
  end

  def duration_in_seconds(duration)
    duration * 3600
  end
end
