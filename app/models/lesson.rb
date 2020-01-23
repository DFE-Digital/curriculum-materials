class Lesson
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :unit_id, :integer
  attribute :complete_curriculum_program_id, :integer
  attribute :name, :string
  attribute :sequence_no, :integer
  attribute :summary, :string
  attribute :core_knowledge, :string
  attribute :previous_knowledge, :string
  attr_accessor :vocabulary, :misconceptions # TODO register new AM::Types

  def self.api_client
    ApiClient
  end

  def self.index(unit_id)
    end_point = ['/units', unit_id, 'lessons'].join('/')
    api_client.get(end_point).map(&method(:new)).map { |m| m.tap(&:validate!) }
  end

  def self.show(id)
    end_point = ['/lessons', id].join("/")
    new(api_client.get(end_point)).tap(&:validate!)
  end

  def persisted?
    id.present?
  end
end
