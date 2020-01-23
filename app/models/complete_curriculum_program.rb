class CompleteCurriculumProgram
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :name, :string
  attribute :overview, :string
  attribute :benefits, :string

  validates :id, :name, :overview, :benefits, presence: true

  def self.api_client
    ApiClient
  end

  def self.index
    end_point = '/ccps'
    api_client.get(end_point).map(&method(:new)).map { |m| m.tap(&:validate!) }
  end

  def self.show(id)
    end_point = ['/ccps', id].join("/")
    new(api_client.get(end_point)).tap(&:validate!)
  end

  def persisted?
    id.present?
  end

  def units
    Unit.index id
  end
end
