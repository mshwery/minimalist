class List < ActiveRecord::Base
  HASHIDS_SALT = Rails.application.secrets.secret_key_base

  validates :name, presence: true
  has_many :tasks, dependent: :destroy

  has_and_belongs_to_many :users

  belongs_to :stack, touch: true
  
  validates_format_of :slug, with: /\A[a-z\-0-9]*\Z/
  before_validation :generate_name, on: :create 
  after_create :update_count

  def self.find_by_token(token)
    slug = nil
    id = nil

    begin
      id = hashids.decode(token).first
    rescue
      slug = token
    end

    find(id || slug)
  end

  def to_param
    List.hashids.encode(id)
  end

  def update_count
    Stat.increment_count_of(:lists_count)
  end

  private

  def self.hashids
    @hashids ||= Hashids.new(HASHIDS_SALT, 10)
  end

  def generate_name
    if self.name.blank?
      self.name = 'untitled'
    end
  end

end
