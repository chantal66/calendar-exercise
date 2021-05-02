# frozen_string_literal: true

require 'time'
require_relative '../../helpers/calendar_helper'

describe CalendarHelper do
  class CalendarHelperTest; end # rubocop:disable  Lint/ConstantDefinitionInBlock

  let(:calendar_test) { CalendarHelperTest.new }
  let(:calendar_helper) { calendar_test.extend(CalendarHelper) }

  let(:time) { Time.parse('10:00') }
  let(:duration) { 3 }

  describe '#time_formatter' do
    it 'returns a formatted time' do
      expect(calendar_helper.time_formatter(time)).to eq('10:00')
    end
  end

  describe '#duration_in_seconds' do
    it 'returns the meeting duration in seconds' do
      expect(calendar_helper.duration_in_seconds(duration)).to eq(duration * 3600)
    end
  end
end
