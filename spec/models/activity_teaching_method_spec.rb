require 'rails_helper'

RSpec.describe ActivityTeachingMethod, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:activity_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:teaching_method_id).of_type(:integer).with_options(null: false) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:activity) }
    it { is_expected.to belong_to(:teaching_method) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:activity_id) }
    it { is_expected.to validate_presence_of(:teaching_method_id) }
  end
end
