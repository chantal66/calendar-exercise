# frozen_string_literal: true

require_relative '../../helpers/calendar_helper'

module CalendarClient
  # Returns a meeting object
  class Meeting
    include CalendarHelper

    attr_reader :name, :duration, :type
    attr_accessor :start_time

    def initialize(params = {})
      raise StandardError unless valid?(params)

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

    def next_starting_time(start_time)
      @start_time = start_time
    end

    def offsite?
      type == :offsite
    end

    def buffer
      offsite? ? 0.5 : 0.0
    end

    def next_meeting_starts
      end_time + duration_in_seconds(buffer)
    end

    def valid?(params)
      return false unless params.is_a?(Hash)
      return false unless params[:name].is_a? String
      return false unless (params[:duration].is_a?(Integer) || params[:duration].is_a?(Float))
      return false unless params[:type].is_a? Symbol
      return false unless [:onsite, :offsite].include?(params[:type])

      true
    end
  end
end
