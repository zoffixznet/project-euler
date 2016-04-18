#!/usr/bin/ruby

class Integer

    def rsum
        return self + self.to_s.reverse.to_i
    end

    def palin?
        s = self.to_s
        return s.reverse == s
    end

    def lycherel?
        n = self.rsum
        for i in 1..50
            if n.palin? then
                return false
            end
            n = n.rsum
        end
        return true;
    end
end

puts ((1..10000).find_all { |n| n.lycherel? }.length)
