require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'columns' do
    it { is_expected.to(have_db_column(:token).of_type(:uuid).with_options(null: false)) }
  end

  describe 'validation' do
    describe '#token' do
      it { is_expected.to(validate_presence_of(:token)) }

      context 'uniqueness' do
        subject { Teacher.new(token: 'aaaaaaaa-bbbb-cccc-1111-222222222222') }

        it { is_expected.to(validate_uniqueness_of(:token).case_insensitive) }
      end
    end
  end

  describe 'Relationships' do
    it { is_expected.to have_many :activity_choices }
    it { is_expected.to have_many(:activities).through :activity_choices }
    it { is_expected.to have_many(:downloads) }
  end
end
