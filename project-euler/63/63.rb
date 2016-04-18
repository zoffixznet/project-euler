#!/usr/bin/ruby

class Integer
    def num_digits
        return to_s.length
    end
end

powers = (1..9).to_a
count = 0
exponent = 1
while powers[-1].num_digits == exponent
    count += powers.find_all { |n| n.num_digits == exponent }.length
    for i in 1..9
        powers[i-1] *= i
    end
    exponent += 1
end
puts count
