Fabricator(:todo) do
  title { Faker::Lorem.words(5).join(' ') }
  status 'open'
  due Date.today
end
