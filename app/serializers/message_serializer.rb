class MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :slug, :description

  has_one :user
end
