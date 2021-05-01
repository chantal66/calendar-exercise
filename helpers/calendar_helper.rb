# frozen_string_literal: true

# formats time
module CalendarHelper
  def time_formatter(time)
    time.strftime('%H:%M')
  end

  def duration_in_seconds(duration)
    duration * 3600
  end
end
