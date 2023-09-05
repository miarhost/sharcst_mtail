class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :last_name, :first_name
end
