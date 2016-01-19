json.set! :id, listing.id
json.set! :title, listing.title
json.set! :user_id, listing.user_id
if listing.user.present?
  json.set! :user, listing.user, partial: 'partials/user_detail', as: :user
end
json.set! :description, listing.description
json.set! :photos, listing.photos
json.set! :address, listing.address
json.set! :city, listing.city
json.set! :state, listing.state
json.set! :country, listing.country
json.set! :lat, listing.lat
json.set! :lon, listing.lon
json.set! :length, listing.length
json.set! :width, listing.width
json.set! :height, listing.height
json.set! :price_min, listing.price_min
json.set! :price_max, listing.price_max
json.set! :access, listing.access
json.set! :environment, listing.environment
