module Statable
  extend ActiveSupport::Concern
  included do
    has_one :recommendations_stat, as: :statable, touch: true
  end
end
