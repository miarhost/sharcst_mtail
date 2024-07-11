module Statable
  extend ActiveSupport::Concern
  included do
    has_one :recommendations_group, as: :statable
  end
end
