class Integer
    def digit_sum
        return self.to_s.split(//s).reduce(0) {|a,b| a + b.to_i}
    end
end

max = 0
for a in (1 .. 99)
    for b in (1 .. 99)
        s = (a**b).digit_sum
        if s > max
            max = s
            puts "#{a} ** #{b} ds= #{s}\n"
        end
    end
end
