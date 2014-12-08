Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  nick_name { Faker::Name.name }
end
