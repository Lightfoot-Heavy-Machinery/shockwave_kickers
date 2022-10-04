require 'csv'
require 'json'

data = File.open('test_data.csv').read()
json = CSV.parse(data).to_json
puts(json)
