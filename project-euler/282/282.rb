#!/usr/bin/ruby
#
#
# Solution taken from:
#
# https://github.com/fw42/projecteuler/blob/master/282.rb .
#
a = 2**8
b = 7**8
pa = (2**7) * (2-1)
pb = (7**7) * (7-1)

def gcd(a,b) (b == 0) ? a : gcd(b, a % b) end

def modpow(base, power, modulus)
  m = base
  pow = power.to_s(2)
  1.upto(pow.length - 1) do |i|
    m = (m*m) % modulus
    m = (m*base) % modulus if pow[i,1] == "1"
  end
  return m
end

lam = (pa * pb) / gcd(a,b)
@xs4 = [ 2**4 - 3, 2**(2**4) - 3 ]
exp = 2**4
loop do
	exp = modpow(2, exp, lam)
	x = (modpow(2, exp, a*b) - 3) % (a*b)
	break if @xs4.include?(x)
	@xs4 << x
end

def A(m,n)
	return n+1 if m == 0
	return 2+(n+3)-3 if m == 1
	return 2*(n+3)-3 if m == 2
	return 2**(n+3)-3 if m == 3
	return @xs4[ [n, @xs4.length-1 ].min ] if m == 4
	return A(m,2) if m == 5 and n > 2
	return A(m-1, 1) if n == 0
	return A(m-1, A(m, n-1))
end

puts [*0..6].map{ |i| A(i,i) }.inject(&:+) % (a*b)
