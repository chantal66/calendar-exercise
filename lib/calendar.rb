# frozen_string_literal: true

require 'time'
require_relative 'meeting'
require_relative '../helpers/calendar_helper'

# returns a set of arranged meetings in a work day
class Calendar
  include CalendarHelper

  OFFICE_HOURS = {
    all_onsite: 8,
    any_offsite: 8.5,
    all_offsite: 9
  }.freeze

  attr_reader :meetings

  def initialize(meetings:)
    @meetings = meetings
  end

  def execute
    meetings_output
  end

  def meeting_initializer
    meetings.map do |meeting|
      meeting[:start_time] = start_time
      Meeting.new(meeting)
    end
  end

  def meetings_output
    unless valid_meeting_duration?
      return "Sorry, You don't have enough hours in your day"
    end

    scheduler.map do |meeting|
      "#{time_formatter(meeting.start_time)} - #{time_formatter(meeting.end_time)} - #{meeting.name.capitalize}"
    end
  end

  def start_time
    Time.parse('09:00')
  end

  def scheduler
    @ordered_meetings = [ordered_meetings.first]

    ordered_meetings.each_with_index do |meeting, index|
      next if index.zero?

      previous_meeting = @ordered_meetings[index - 1]
      next_starting_time = previous_meeting.next_meeting_starts
      meeting.next_starting_time(next_starting_time)
      meeting.end_time

      @ordered_meetings << meeting
    end
    @ordered_meetings
  end

  def total_meetings_duration
    offsite_meetings_duration + onsite_meeting_duration
  end

  def offsite_meetings_duration
    offsite_meetings.reduce(0) { |sum, meeting| sum + (meeting.duration + 0.5) }
  end

  def onsite_meeting_duration
    onsite_meetings.reduce(0) { |sum, meeting| sum + meeting.duration }
  end

  def ordered_meetings
    meeting_initializer.sort_by(&:type).reverse
  end

  def offsite_meetings
    meeting_initializer.select { |meeting| meeting.type == :offsite }
  end

  def onsite_meetings
    meeting_initializer.select { |meeting| meeting.type == :onsite }
  end

  def valid_meeting_duration?
    return false if total_meetings_duration >= OFFICE_HOURS[:any_offsite]
    return false if offsite_meetings_duration >= OFFICE_HOURS[:all_offsite]
    return false if onsite_meeting_duration >= OFFICE_HOURS[:all_onsite]

    true
  end
end
