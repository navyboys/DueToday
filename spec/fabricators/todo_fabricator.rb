Fabricator(:todo) do
  name { Faker::Lorem.words(5).join(' ') }
  status { Faker::Lorem.word }
  due Date.today
end
