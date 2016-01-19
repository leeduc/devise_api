json.partial! 'layouts/format', object: OpenStruct.new
json.entities [@resource], partial: 'partials/user_detail', as: :user
