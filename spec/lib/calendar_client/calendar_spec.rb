# frozen_string_literal: true

require 'time'
require_relative '../../../lib/calendar_client/calendar'

describe CalendarClient::Calendar do

  let(:start_time) { Time.parse('09:00') }

  let(:onsite_meetings) do
    [
      { name: 'Meeting 1', duration: 3, type: :onsite },
      { name: 'Meeting 2', duration: 3, type: :onsite }
    ]
  end

  let(:meetings) do
    [
      { name: 'Meeting 1', duration: 3, type: :onsite },
      { name: 'Meeting 2', duration: 2, type: :offsite },
      { name: 'Meeting 3', duration: 1, type: :offsite },
      { name: 'Meeting 4', duration: 0.5, type: :onsite }
    ]
  end

  let(:non_fitting_meetings) do
    [
      { name: 'Meeting 1', duration: 4, type: :offsite },
      { name: 'Meeting 2', duration: 4, type: :offsite }
    ]
  end

  subject { described_class.new(meetings: meetings) }

  describe '#meeting_initializer' do
    it 'returns a meeting object' do
      expect(subject).to be_instance_of CalendarClient::Calendar
      expect(subject.meetings).to be_an Array
      expect(subject.meetings.first.name).to eq('Meeting 1')
      expect(subject.meetings.first.duration).to eq(3)
      expect(subject.meetings.first.type).to eq(:onsite)
      expect(subject.meetings.first.start_time).to eq(start_time)
      expect(subject.meetings.first.end_time).to eq(start_time + (subject.meetings.first.duration * 3600))
    end
  end

  describe '#call' do
    context 'when meetings fit office hours' do
      it 'returns a meeting schedule' do
        expect(subject.call).to be_an Array
        expect(subject.call).to eq(["09:00 - 09:30 - Meeting 4",
                                    "09:30 - 12:30 - Meeting 1",
                                    "12:30 - 13:30 - Meeting 3",
                                    "14:00 - 16:00 - Meeting 2"])
      end
    end

    context 'when meetings does not fit office hours' do
      subject { described_class.new(meetings: non_fitting_meetings) }

      it 'returns a message' do
        expect(subject.call).to eq("Sorry, You don't have enough hours in your day")
      end
    end
  end

  describe '#total_meeting_duration' do
    context 'when meetings include an offsite meeting' do
      it 'returns the sum of all meetings duration with buffer' do
        expect(subject.total_meetings_duration).to eq(7.5)
      end
    end

    context 'when meetings do not include an offsite meeting' do
      subject { described_class.new(meetings: onsite_meetings) }

      it 'returns the sum of all meetings duration without buffer' do
        expect(subject.total_meetings_duration).to eq(6)
      end
    end
  end

  describe '#ordered_meetings' do
    it 'returns a set of meetings ordered by type' do
      expect(subject.ordered_meetings.first.type).to eq(:onsite)
      expect(subject.ordered_meetings[1].type).to eq(:onsite)
      expect(subject.ordered_meetings[2].type).to eq(:offsite)
      expect(subject.ordered_meetings.last.type).to eq(:offsite)
    end
  end

  describe '#valid_meeting_duration?' do
    context 'when meetings have valid durations' do
      it 'returns true' do
        expect(subject.valid_meeting_duration?).to eq(true)
      end
    end

    context 'when meetings have wrong durations' do
      subject { described_class.new(meetings: non_fitting_meetings) }

      it 'returns true' do
        expect(subject.valid_meeting_duration?).to eq(false)
      end
    end
  end
end
