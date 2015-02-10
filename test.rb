require 'json'
array_of_pairs = "AZ (7), CA (88), CO (1), DC (1), DE (1), IL (3), MI (1), MN (1), NE (2), NJ (1), NY (2), NV (2), OR (1), PA (1), SD (2) TX (1), UT (2), WA (4)".split(", ").map {|item| item.split(" ") }

array_of_pairs.each_with_index do |item,index|
  array_of_pairs[index][1] = array_of_pairs[index][1].gsub(/[()]/,"")
end

hash_data = {}
puts array_of_pairs.inspect
array_of_pairs.each_with_index do |item,index|
  hash_data[array_of_pairs[index][0]] = array_of_pairs[index][1]
end
largest = hash_data.values.sort.last.to_i

hash_data.each do |key,value|
  hash_data[key] = {cases: value}
  if value.to_i == 88
    hash_data[key]["fillKey"] = "HIGH"
  elsif value.to_i == 1
    hash_data[key]["fillKey"] = "LOW"
  else
    hash_data[key]["fillKey"] = "MEDIUM"
  end
end
puts hash_data.to_json