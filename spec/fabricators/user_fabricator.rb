Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  name { Faker::Name.name }
  time_zone 'Pacific Time (US & Canada)'
end
