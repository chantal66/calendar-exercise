require 'time'
require_relative 'meeting'

class Calendar
  attr_reader :meetings

  def initialize(meetings:)
    @meetings = meetings
  end

  def meeting_initializer
    meetings.map do |meeting|
      meeting[:start_time] = start_time
      Meeting.new(meeting)
    end
  end

  def execute
    require 'pry'
    binding.pry
  end

  def start_time
    Time.parse("09:00")
  end
end

# temp call to class
Calendar.new(meetings: [{:name=>"Meeting 2", :duration=>2, :type=>:offsite}, {:name=>"Meeting 3", :duration=>1, :type=>:offsite}, {:name=>"Meeting 1", :duration=>3, :type=>:onsite}, {:name=>"Meeting 4", :duration=>0.5, :type=>:onsite}]).execute

