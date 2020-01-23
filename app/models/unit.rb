class Unit
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :complete_curriculum_program_id, :integer
  attribute :name, :string
  attribute :overview, :string
  attribute :benefits, :string

  validates :id, :name, :overview, :benefits, presence: true

  def self.api_client
    ApiClient
  end

  def self.index(complete_curriculum_program_id)
    end_point = ['/ccps', complete_curriculum_program_id, 'units'].join('/')
    api_client.get(end_point).map(&method(:new)).map { |m| m.tap(&:validate!) }
  end

  def self.show(id)
    end_point = ['/units', id].join("/")
    new(api_client.get(end_point)).tap(&:validate!)
  end

  def persisted?
    id.present?
  end

  def lessons
    Lesson.index id
  end
end
