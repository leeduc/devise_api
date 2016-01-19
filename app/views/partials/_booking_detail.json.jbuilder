json.set! :id, booking.id
json.set! :listing_id, booking.listing_id
json.set! :user_id, booking.user_id
json.set! :price, booking.price
json.set! :price_month, booking.price_month
json.set! :start_at, booking.start_at
json.set! :end_at, booking.end_at
json.set! :created_at, booking.created_at
json.set! :updated_at, booking.updated_at
json.set! :user, booking.user, partial: 'partials/user_detail', as: :user if booking.user.present?
json.set! :listing, booking.listing, partial: 'partials/listing_detail', as: :listing if booking.listing.present?
