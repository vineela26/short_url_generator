class Link < ApplicationRecord
  has_many :link_stats

  validates_presence_of :url
  validates :url, format: URI::regexp(%w[http https])
  #validates_uniqueness_of :short_url
  before_validation :generate_short_url

  def generate_short_url
    generated_url = ([*('a'..'z'),*('0'..'9')]).sample(5).join
    duplicate_url = Link.where(short_url: generated_url).last
    self.generate_short_url if duplicate_url.present?
    generated_url
  end


end
