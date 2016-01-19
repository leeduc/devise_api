if object.version.present?
  json.version object.version
else
  json.version "1.0"
end

json.status "error"

if object.errors.present?
    json.errors object.errors
end

if object.message.present?
    json.message object.message
end
