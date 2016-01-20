use v6;

my Int sub count_primes_up_to(Int $n)
{
    my $out = qq:x{primesieve "$n" "-c1"};
    my $m = $out ~~ m:P5/Prime numbers\s*:\s*([0-9]+)/;
    return Int($0);
}

# say count_primes_up_to(10000);

=begin foo

def brute_force_calc_s(n):
    out = check_output(["primesieve", str(n), "-p1"])
    primes = [long(x) for x in out.split("\n") if len(x)]
    h1 = {}
    for x in primes:
        h1[x] = True
    s = len(h1.keys())
    h = h1
    for k in range(2,n):
        next_h = {}
        for num in h.keys():
            for p in primes:
                next_num = num + p
                if next_num <= n:
                    next_h[next_num] = True
        s += len(next_h.keys())
        h = next_h
    return s

=end foo

=cut

my Int sub calc_s(Int $n)
{
    if $n == 2
    {
        return [2].Int;
    }
    if $n == 3
    {
        return [2,3].Int;
    }
    if $n == 5
    {
        return [2,3,5,2+2,2+3].Int;
    }
    if $n == 8
    {
        return [2,3,5,7,2+2,2+3,2+5,3+3,3+5,2+2+2,2+2+3,2+3+3,2+2+2+2].Int;
    }
    # Calc s[k=1].
    my Int $s_1 = count_primes_up_to($n);
    # Calc s[k=2] for i odd.
    my Int $s_2 = count_primes_up_to(((($n +& 0x1) == 1) ?? $n !! $n-1)-2)-1;
    # Calc the higher s-s for even numbers.
    my Int $top_even = ($n +& (+^0x1));
    my Int $bottom_even = 4;
    my Int $even_count_for_k_2 = (($top_even - $bottom_even) +> 1) + 1;
    my Int $even_s = (($even_count_for_k_2 * (1+$even_count_for_k_2)) +> 1);

    # Calc the higher s-s for odd numbers.
    my Int $top_odd = ((($n +& 0x1) == 1) ?? $n !! $n-1);
    my Int $bottom_odd = 2+2+3;
    my Int $odd_count_for_k_3 = (($top_odd - $bottom_odd) +> 1) + 1;
    my Int $odd_s = (($odd_count_for_k_3 * (1+$odd_count_for_k_3)) +> 1);

    return $s_1 + $s_2 + $even_s + $odd_s;
}

my @fibs = (0,1);
while @fibs.Int < 45 {
    @fibs.push(@fibs[*-1]+@fibs[*-2]);
}

say "Result = ", (map { calc_s($_) } , @fibs[3..44]).sum();

=begin foo

def print_s(n):
    print (("S[%d] = %d" % (n, calc_s(n))))
    return

print_s(10)
print_s(100)
print_s(1000)

def check_print_s(n):
    calced = calc_s(n)
    real = brute_force_calc_s(n)
    print (("S[%d] = Real = %d ; Calc = %d" % (n, real, calced)))
    if (real != calced):
        raise BaseException
    return

check_print_s(10)
check_print_s(100)
check_print_s(11)
check_print_s(21)
check_print_s(101)
print ("Result = %d" % (sum([calc_s(fibs[k]) for k in range(3,45)])))
=end foo

=cut
