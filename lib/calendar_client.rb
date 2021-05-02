# frozen_string_literal: true

require 'yaml'
require 'pry'

module CalendarClient
  MEETINGS_FILE = YAML.load(File.read('config/meetings.yml'), symbolize_names: true)

  attr_reader :day_1

  def self.execute
    # you can switch :day_1 for :day_2, :day_3 or :day_4
    CalendarClient::Calendar.new(meetings: MEETINGS_FILE.first[:day_1]).call
  end

  require_relative 'calendar_client/meeting'
  require_relative 'calendar_client/calendar'
  require_relative 'calendar_client/version'
  require_relative '../helpers/calendar_helper'
end
