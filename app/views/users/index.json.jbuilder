json.partial! 'layouts/format', object: OpenStruct.new
json.meta meta_pagination @resources
json.links do
  json.next next_link query
end
json.entities @resources, partial: 'partials/user_detail', as: :user
