class ApplicationRecord < ActiveRecord::Base
  include Localizable
  include TranslateEnum
  include Searchable
  primary_abstract_class
end
