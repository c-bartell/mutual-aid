class ExternalResource < ApplicationRecord
  taggable_array :tags

  belongs_to :system_location
  belongs_to :organization, optional: true # TODO - should this be optional???

  has_many :matches, as: :matchable_asker
  has_many :matches, as: :matchable_offerer

  def self.published
    now_strftime = Time.now.strftime("%Y-%m-%d %H:%M")

    where(approved: true).
        where("(publish_from IS NOT NULL AND publish_from <= '#{ now_strftime }') AND
           (publish_until IS NULL OR '#{ now_strftime }' <= COALESCE(publish_until, now()) )")
  end

  def published?
    now = Time.now
    approved &&
    (publish_from.present? ? publish_from <= now : true) &&
      (publish_until == nil || now < publish_until)
  end

end
