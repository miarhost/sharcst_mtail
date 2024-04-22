module Locatable
extend ActiveSupport::Concern
has_many :locations, as: :locatable, polymorphic: true
