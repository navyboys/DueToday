Fabricator(:todo) do
  title { Faker::Lorem.words(5).join(' ') }
  status { Faker::Lorem.word }
  due Date.today
end
