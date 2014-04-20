#!/usr/bin/ruby

class Integer
    def permutation_signature
        return to_s.split(//).sort.join
    end
    def cube
        return self ** 3
    end
end

$m = {}

n = 1
while true
    c = n.cube
    sign = c.permutation_signature
    $m[sign] ||= []
    $m[sign].push(c)
    if ($m[sign].length == 5)
        puts $m[sign][0]
    end
    n +=1
end

