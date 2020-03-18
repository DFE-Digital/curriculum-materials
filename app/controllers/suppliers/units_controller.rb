module Suppliers
  class UnitsController < ApplicationController
    layout 'editor'

    # FIXME unused atm, not sure if required
    def index
      @units = Unit.all
    end

    def show
      @unit = Unit
        .eager_load(:complete_curriculum_programme)
        .find(params[:id])

      @ccp = @unit.complete_curriculum_programme
    end
  end
end
