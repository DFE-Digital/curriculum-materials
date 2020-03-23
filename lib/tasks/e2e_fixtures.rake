def save_class(klass)
  klass = klass.to_s
  basename = ActiveSupport::Inflector.pluralize(klass).downcase
  File.open(File.join(Rails.root, "cypress/fixtures/#{basename}.json"), 'w') do |f|
    f.write("#{klass.classify}Serializer".constantize.render(klass.classify.constantize.all))
  end
end

namespace :e2e do
  namespace :fixtures do
    desc "Export fixtures for E2E testing"
    task all: %i(ccps units lessons)

    desc "Export Complete Curriculum Program fixtures"
    task ccps: :environment do
      save_class(:complete_curriculum_programme)
    end

    desc "Export Unit fixtures"
    task units: :environment do
      save_class(:unit)
    end

    desc "Export Lesson fixtures"
    task lessons: :environment do
      save_class(:lesson)
    end
  end
end
