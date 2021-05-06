# frozen_string_literal: true

require 'yaml'
require 'pry'

# Returns output of a set of meetings
module CalendarClient
  MEETINGS_FILE = YAML.load(File.expand_path('config/meetings.yml', File.dirname(__FILE__)), symbolize_names: true)

  def self.execute
    CalendarClient::Calendar.new(meetings: MEETINGS_FILE.first[:day1]).call
  end

  require_relative 'calendar_client/meeting'
  require_relative 'calendar_client/calendar'
  require_relative 'calendar_client/version'
  require_relative '../helpers/calendar_helper'
end
