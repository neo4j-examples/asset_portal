
json.users @users do |user|
  json.extract! user, :id, :username, :name
end

json.groups @groups do |group|
  json.extract! group, :id, :name
end
