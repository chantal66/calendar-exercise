# frozen_string_literal: true

require 'time'
require_relative '../../../lib/calendar_client/meeting'

describe CalendarClient::Meeting do # rubocop:disable Metrics/BlockLength
  let(:start_time) { Time.parse('09:00') }

  let(:onsite_meeting) do
    { name: 'Meeting 1', duration: 3, type: :onsite, start_time: start_time }
  end

  let(:offsite_meeting) do
    { name: 'Meeting 2', duration: 2, type: :offsite, start_time: start_time }
  end

  let(:bad_params) { { name: 'Meeting 2', duration: '2', type: :offsite, start_time: start_time } }


  subject { described_class.new(onsite_meeting) }

  describe '#initialize' do
    it 'with right arguments' do
      expect(subject.name).to eql onsite_meeting[:name]
      expect(subject.duration).to eql onsite_meeting[:duration]
      expect(subject.type).to eql onsite_meeting[:type]
      expect(subject.start_time).to eql onsite_meeting[:start_time]
    end

    it 'returns the end_time of the meeting' do
      expect(subject.end_time).to eql(start_time + (onsite_meeting[:duration] * 3600))
    end
  end

  describe '#valid?' do
    context 'with correct params' do
      it 'returns true' do
        expect(subject.valid?(onsite_meeting)).to eq(true)
      end
    end

    context 'with incorrect params' do
      it { expect{described_class.new(bad_params)}.to raise_error(StandardError) }
    end
  end

  describe '#offsite?' do
    context 'when onsite' do
      it 'returns false' do
        expect(subject.offsite?).to eq(false)
      end
    end

    context 'when offsite' do
      subject { described_class.new(offsite_meeting) }

      it 'returns true' do
        expect(subject.offsite?).to eq(true)
      end
    end
  end

  describe '#buffer' do
    context 'when onsite' do
      it 'returns 0.0' do
        expect(subject.buffer).to eq(0.0)
      end
    end

    context 'when offsite' do
      subject { described_class.new(offsite_meeting) }

      it 'returns 0.5' do
        expect(subject.buffer).to eq(0.5)
      end
    end
  end

  describe '#next_meeting_starts' do
    context 'when onsite' do
      it 'returns the end_time without buffer' do
        expect(subject.next_meeting_starts).to eq(subject.end_time)
      end
    end

    context 'when offsite' do
      it 'returns the end_time with buffer' do
        expect(subject.next_meeting_starts).to eq(subject.end_time + subject.buffer)
      end
    end
  end
end
