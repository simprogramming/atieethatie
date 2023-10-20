module Searchable
  extend ActiveSupport::Concern
  include PgSearch::Model

  included do
    def self.searchable(*columns, **associations)
      define_singleton_method(:searchable?) { true }

      pg_search_scope :search,
                      against: columns,
                      associated_against: associations,
                      ignoring: :accents,
                      using: {
                        tsearch: { prefix: true },
                        trigram: {}
                        # trigram: { word_similarity: true }
                      }
    end
  end
end
