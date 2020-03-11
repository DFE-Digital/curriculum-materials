require 'rails_helper'

RSpec.describe 'SchoolYear' do
  subject { SchoolYear.instance }

  mapping = {
    1 => 1..2,
    2 => 3..6,
    3 => 7..9,
    4 => 10..11,
  }

  specify 'contains a mapping of key stages to schools' do
    expect(SchoolYear::MAPPING).to eql(mapping)
  end

  describe 'methods' do
    describe '#years' do
      it { is_expected.to respond_to(:years) }

      specify 'should be 1-11' do
        expect(subject.years).to eql((1..11).to_a)
      end
    end

    describe '#key_stages' do
      it { is_expected.to respond_to(:key_stages) }

      specify 'should be 1-4' do
        expect(subject.key_stages).to eql((1..4).to_a)
      end
    end

    describe '#years_at and #key_stage_for' do
      it { is_expected.to respond_to(:years_at).with_keywords(:key_stage) }
      it { is_expected.to respond_to(:key_stage_for).with_keywords(:year) }

      mapping.each do |key_stage, years|
        describe "Key stage #{key_stage} includes:" do
          years.each do |year|
            specify "Year #{year}" do
              expect(subject.years_at(key_stage: key_stage)).to include(year)
              expect(subject.key_stage_for(year: year)).to eql(key_stage)
            end
          end
        end
      end
    end
  end
end
