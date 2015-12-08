class Todo < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ['duetoday', Rails.env].join('-')

  belongs_to :user
  validates :title, presence: true
  before_create :set_default_value

  def copy_to_today
    todo_copy = dup
    todo_copy.status = 'open'
    todo_copy.due = user.today
    todo_copy.save
  end

  def completed?
    status == 'completed'
  end

  def failed?
    status == 'failed'
  end

  def self.search(query)
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ['title'],
          operator: 'and'
        }
      }
    }
    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(*)
    as_json(only: [:title])
  end

  private

  def set_default_value
    self.status = 'open' if status.blank?
    self.due = user.today if due.blank?
  end
end
