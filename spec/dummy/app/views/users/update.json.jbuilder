json.partial! 'layouts/format', object: OpenStruct.new
json.entities [@comment], partial: 'partials/comment_detail', as: :comment
