json.set! :id, message.id
json.set! :user_id, message.user_id
json.set! :room_id, message.room_id
json.set! :booking_id, message.booking_id
json.set! :listing_id, message.listing_id
json.set! :content, message.content
json.set! :created_at, message.created_at
json.set! :updated_at, message.updated_at
json.set! :user, message.user, partial: 'partials/user_detail', as: :user
json.set! :booking, message.booking, partial: 'partials/booking_detail', as: :booking if message.booking_id.present?
