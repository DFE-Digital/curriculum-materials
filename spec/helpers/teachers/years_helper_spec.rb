require 'rails_helper'

describe Teachers::YearsHelper, type: :helper do
  describe '#unit_card_class' do
    context 'when a unit has lessons' do
      let(:unit) { create(:unit, :with_lessons) }

      it 'should return the edit lesson part choice path' do
        expect(helper.unit_card_class(unit)).to eql('card-with-lessons')
      end
    end

    context 'when a unit has no lessons' do
      let(:unit) { create(:unit) }

      it 'should return the edit lesson part choice path' do
        expect(helper.unit_card_class(unit)).to eql('card-without-lessons')
      end
    end
  end
end
