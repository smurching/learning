class TopicSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :prereqs
  has_many :postreqs
  has_many :links
  embed :ids, include: true, embed_in_root: true
end