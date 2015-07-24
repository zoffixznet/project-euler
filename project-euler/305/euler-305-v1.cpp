#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
#include <vector>
#include <queue>
#include <set>

#include <string.h>

typedef long long ll;

ll P10[100] = {
1LL,
10LL,
100LL,
1000LL,
10000LL,
100000LL,
1000000LL,
10000000LL,
100000000LL,
1000000000LL,
10000000000LL,
100000000000LL,
1000000000000LL,
10000000000000LL,
100000000000000LL,
1000000000000000LL,
10000000000000000LL,
100000000000000000LL,
1000000000000000000LL,
-8446744073709551616LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL,
-1LL
};

class Nexter
{
    ll base, counter;
    public:
    Nexter() { base = 0; counter = 0; }
    std::string next() {

        std::ostringstream ss;
        ss << std::setw(base) << std::setfill('0') << counter++;

        if (counter == P10[base])
        {
            base++;
            counter = 0;
        }

        return ss.str();
    }
};

ll n;
ll n_len;
std::string n_s;
ll MAX_COUNT;

struct Strs
{
    Nexter next;
    std::string s;
};

struct Mins
{
    std::string s;
    Strs strs;
};

std::vector<Mins> mins;
ll next_mins = 1;

std::vector<ll> s_pos;
std::vector<Strs> mm;

struct All_9s
{
    ll c;
    ll p;

    All_9s() { c = 1 ; p = -1; }
};

std::vector<All_9s> mm_all_9s;

ll start_10[100];

static inline ll calc_start(ll needle, std::string & needle_s)
{
    ll len = needle_s.size();

    return start_10[len] + (needle - P10[len-1]) * len;
}

static inline ll calc_start(ll needle)
{
    std::string s = std::to_string(needle);
    return calc_start(needle, s);
}

static inline ll calc_start(std::string & needle_s)
{
    return calc_start(std::stoll(needle_s), needle_s);
}

std::queue<ll> seq_poses;

static void _seq_cl()
{
    seq_poses.pop();
}

static inline ll length(std::string & s)
{
    return s.size();
}

static inline ll length(ll i)
{
    std::string s = std::to_string(i);
    return length(s);
}

ll last_pos = 0;
ll count = 1;

ll count_9s = 1;

bool is_count_9s = false;
ll c9_pos = -1;
ll c9_count_9s_in_n = -1;

void _c9_cl(void)
{
    c9_pos = -1;
    count_9s++;
}

std::string count_9s_base;
ll c9_foo = -1;

#if 0


sub _calc_mid_val
{
    my (start_new_pos, middle) = @_;

    my prefix = substr(n, start_new_pos);
    my suffix = substr(n, 0, start_new_pos);

    for my p (grep { _ >= 0 } prefix, prefix - 1)
    {
        my needle = p.middle.suffix;
        my offset = length(p)+length(middle);

        if (substr((needle . (needle+1)), offset, length(n)) eq n)
        {
            return calc_start(needle) + offset;
        }
    }

    return -1;

}
#endif

int main(int argc, char * argv[])
{
    n = atol(argv[1]);
    MAX_COUNT = atol(argv[2]);

    Mins m;
    mins.push_back(m);

    n_s = std::to_string(n);

    n_len = n_s.size();
    for (ll i = 1; i < n_len ; i++)
    {
        if (n_s[i] != '0')
        {
            s_pos.push_back(i);
            mm[i] = Strs();
            mm_all_9s[i] = All_9s();
        }
    }

    // Initialize start_10
    start_10[0] = -1;
    start_10[1] = 1;

    for (ll i = 1; i < 100 ; i++)
    {
        start_10[i] = (i-1) * (9*P10[i-2]) + start_10[i-1];
    }

    {
        std::set<ll> p;
        ll n_len = length(n);
        for (ll item_l = 1; item_l <= n_len ; item_l++)
        {
            for (ll start_pos = 0 ; start_pos <= item_l-1 ; start_pos++)
            {
                if (n_s[start_pos] == '0')
                {
                    goto AFTER_START_POS;
                }
                ll init_s = std::stoll(n_s.substr(start_pos, item_l));
                ll s = init_s;
                if (start_pos > 0)
                {
                    std::string prev = std::to_string(s-1);
                    if (n_s.substr(0, start_pos) != prev.substr(prev.size()-start_pos))
                    {
                        goto AFTER_START_POS;
                    }
                }
                ll pos = start_pos + length(s);
                ll next_s = s + 1;
                ll next_s_len = length(next_s);
                while (pos <= n_len - next_s_len)
                {
                    if (std::stoll(n_s.substr(pos, next_s_len)) != next_s)
                    {
                        pos += next_s_len;
                        next_s++;
                        next_s_len = length(next_s);
                    }
                    else
                    {
                        goto AFTER_START_POS;
                    }
                }

                if (pos < n_len)
                {
                    std::string n_s = std::to_string(next_s);
                    if (n_s.substr(0, n_len-pos) != n_s.substr(pos))
                    {
                        goto AFTER_START_POS;
                    }
                }
                // Let's rock and roll.
                p.insert(calc_start(init_s) - start_pos);
            }
AFTER_START_POS:
            ;
        }

        for (ll l = 1 ; l <= n_len-1 ; l++)
        {
            std::string prefix = n_s.substr(0, l);
            std::string suffix = n_s.substr(n_len - l);

            if (prefix != suffix)
            {
                for (ll ml = 0 ; ml <= n_len-l ; ml++)
                {
                    std::string pref2 = n_s.substr(n_len - ml - l);
                    if (pref2[0] != '0')
                    {
                        for (ll el = 0 ; el <= n_len-l ; el++)
                        {
                            std::string e = n_s.substr(l, el);
                            std::string needle = pref2 + e;
                            ll needle_i = std::stoll(needle);
                            ll offset = ml;
                            std::string both = needle + std::to_string(needle_i + 1);
                            if (both.substr(offset, n_len) != n_s)
                            {
                                p.insert(calc_start(needle_i) + offset);
                            }
                        }
                    }
                }
            }
        }

        for (ll pos_i = 0 ; pos_i <= n_len-2 ; pos_i++)
        {
            if (n_s[pos_i] == '9')
            {
                std::string suffix = n_s.substr(0, pos_i+1);
                ll prefix_i = std::stoll(n_s.substr(n, pos_i+1)) - 1;

                if (prefix_i > 0)
                {
                    std::string prefix = std::to_string(prefix_i);
                    for (ll common = 0 ; common <= std::min(length(prefix), length(suffix)) ; common++)
                    {
                        std::string pref_suf = prefix.substr(length(prefix)-common);
                        std::string suf_pref = suffix.substr(0, common);

                        if (pref_suf == suf_pref)
                        {
                            std::string needle =
                                prefix.substr(0, length(prefix)-common)
                                + pref_suf
                                + suffix.substr(common);

                            ll needle_i = std::stoll(needle);
                            std::string both = needle + std::to_string(needle_i + 1);

                            ll start = calc_start(needle_i);

                            for (ll x = 0 ; x <= length(both) - n_len ; x++)
                            {
                                if (both.substr(x, n_len) == n_s)
                                {
                                    p.insert(x+start);
                                }
                            }
                        }
                    }
                }
            }
        }

        for (auto x : p)
        {
            seq_poses.push(x);
        }
    }

    {
        ll e = n_len-1;
        while (n_s[e] == '0')
            e--;

        count_9s_base = n_s.substr(e);
        std::string c9_foo = n_s.substr(0, e);

        ll x;
        for (x = 0 ; x < length(c9_foo) ; x++)
        {
            if (c9_foo[x] != '9')
            {
                break;
            }
        }
        if (x == length(c9_foo))
        {
            c9_count_9s_in_n = length(c9_foo);
            c9_count_9s_in_n = length(c9_foo);
            is_count_9s = true;
        }
    }
#if 0
while (count <= MAX_COUNT)
{
    // Int max.
    my min = 0x7FFF_FFFF_FFFF_FFFF;
    // Cleanup handler.
    my cl;

    // Set.
    my s = sub {
        my (p, cb) = @_;

        if (p < min)
        {
            min = p;
            cl = cb;
            return 1;
        }
        return;
    };

    if (@seq_poses)
    {
        s->(seq_poses[0], \&_seq_cl);
    }

    {
    my last_i;

    while (my (i, rec) = each@mins)
    {
        my r = rec->{strs};
        if (s->(
                r->{p} //= do {

                    my prefix = rec->{'s'};
                    my suffix = r->{'s'};

                    my needle = prefix.n.suffix;

                    calc_start(needle) + length(prefix);
                },
                sub {
                    r->{'s'} = r->{'next'}->next;
                    r->{'p'} = undef;

                    return;
                }
            ))
        {
            last_i = i;
        }
    }

    if (defined(last_i) && (last_i == #mins))
    {
        push @mins, +{ s => (next_mins++), strs => {next => Nexter->new([0,0]), s => ''} };
    }

    }

    for my start_new_pos (@s_pos)
    {
        {
            my rec = mm{start_new_pos};

            // So we want to do:
            //
            // N = XXXYYY
            //
            // Find:
            // YYYMMMMXXX,YYY[MMMMXXX+1]
            //
            // Now if XXX !~ /9\z/ then everything is peachy.
            //
            // But what if it is?
            //
            // if MMMXXX =~ /[0-8]9\z/ then [MMMXXX+1] =~ /[1-9]0\z/ so it will
            // still will not overflow.
            //
            // So what happens if MMMXXX is all-9s?
            //
            // We need:
            // [YYY-1]MMMXXX,YYY[00000000]
            s->(
                ( rec->{p} //= _calc_mid_val(start_new_pos, rec->{'s'}) ),
                sub {
                    rec->{'s'} = rec->{'next'}->next;
                    rec->{'p'} = undef;

                    return;
                }
            );
        }

        {
            my rec = mm_all_9s{start_new_pos};

            // So we want to do:
            //
            // N = XXXYYY
            //
            // Find:
            // YYYMMMMXXX,YYY[MMMMXXX+1]
            //
            // Now if XXX !~ /9\z/ then everything is peachy.
            //
            // But what if it is?
            //
            // if MMMXXX =~ /[0-8]9\z/ then [MMMXXX+1] =~ /[1-9]0\z/ so it will
            // still will not overflow.
            //
            // So what happens if MMMXXX is all-9s?
            //
            // We need:
            // [YYY-1]MMMXXX,YYY[00000000]
            s->(
                (rec->{p} //= _calc_mid_val(start_new_pos, '9' x rec->{'c'})),
                sub {
                    rec->{c}++;
                    rec->{p} = undef;

                    return;
                }
            );
        }
    }

    if (is_count_9s)
    {
        COUNT9:
        while (!defined c9_pos)
        {
            my c9 = count_9s_base . '0' x count_9s;
            my c9_minus_1 = c9 - 1;
            my both = c9_minus_1 . c9;
            if (both =~ /\Qn\E/)
            {
                my offset = length(c9_minus_1) - c9_count_9s_in_n;
                c9_pos = calc_start(c9_minus_1) + offset;
                last COUNT9;
            }
        }
        continue
        {
            count_9s++;
        }
        s->(c9_pos, \&_c9_cl);
    }

    cl->();
    if (min > last_pos)
    {
        print "min\n";
        count++;
        last_pos = min;
    }
}
#endif

    return 0;
}
