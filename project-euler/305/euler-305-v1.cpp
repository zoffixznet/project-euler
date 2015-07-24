#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
#include <vector>
#include <queue>
#include <set>

#include <string.h>
#include <stdlib.h>

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
    ll p;
    Strs() { p = -1; }
};

struct Mins
{
    std::string s;
    Strs strs;
};

std::vector<Mins *> mins;
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

static inline ll calc_start(ll needle, const std::string & needle_s)
{
    ll len = needle_s.size();

    return start_10[len] + (needle - P10[len-1]) * len;
}

static inline ll calc_start(ll needle)
{
    const std::string s = std::to_string(needle);
    return calc_start(needle, s);
}

static inline ll calc_start(const std::string & needle_s)
{
    return calc_start(std::stoll(needle_s), needle_s);
}

std::queue<ll> seq_poses;

static void _seq_cl()
{
    seq_poses.pop();
}

static inline ll length(const std::string & s)
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

static void _c9_cl()
{
    c9_pos = -1;
    count_9s++;
}

std::string count_9s_base;
ll c9_foo = -1;

static inline ll _calc_mid_val(const ll start_new_pos, const std::string & middle)
{
    std::string prefix = n_s.substr(start_new_pos);
    std::string suffix = n_s.substr(0, start_new_pos);

    ll prefix_i = std::stoll(prefix);

    for (int off=0; off >= -1; off--)
    {
        const ll p = prefix_i+off;
        if (p >= 0)
        {
            const std::string p_s = std::to_string(p);
            const std::string needle = p_s + middle + suffix;
            const ll offset = length(p_s) + length(middle);

            const ll needle_i = std::stoll(needle);
            const std::string both = needle + std::to_string(needle_i + 1);
            if (both.substr(offset, n_len) == n_s)
            {
                return calc_start(needle_i) + offset;
            }
        }
    }

    return -1;

}


// Int max.
ll min;

// Cleanup handler.
void (*cl)();

// Set.
static inline bool s(const ll p, void (*cb)())
{
    if (p < min)
    {
        min = p;
        cl = cb;
        return true;
    }
    else
    {
        return false;
    }
}

Strs * clear_strs_ptr;

static void _clear_strs(void)
{
    clear_strs_ptr->s = clear_strs_ptr->next.next();
    clear_strs_ptr->p = -1;
}

ll all_9s_start_new_pos;

static void _clear_all_9s(void)
{
    auto & rec = mm_all_9s[all_9s_start_new_pos];
    rec.c++;
    rec.p = -1;
}

int main(int argc, char * argv[])
{
    n = atol(argv[1]);
    MAX_COUNT = atol(argv[2]);

    const bool verbose = getenv("QUIET") ? false : true;

    Mins * m = new Mins;
    mins.push_back(m);

    n_s = std::to_string(n);

    n_len = n_s.size();
    mm.push_back(Strs());
    mm_all_9s.push_back(All_9s());
    for (ll i = 1; i < n_len ; i++)
    {
        if (n_s[i] != '0')
        {
            s_pos.push_back(i);
        }
        mm.push_back(Strs());
        mm_all_9s.push_back(All_9s());
    }

    // Initialize start_10
    start_10[0] = -1;
    start_10[1] = 1;

    for (ll i = 2; i < 100 ; i++)
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
                    if (std::stoll(n_s.substr(pos, next_s_len)) == next_s)
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

            if (prefix == suffix)
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

    while (count <= MAX_COUNT)
    {
        min = 0x7FFFFFFFFFFFFFFFLL;

        if (! seq_poses.empty())
        {
            s(seq_poses.front(), _seq_cl);
        }

        {
            ll last_i = -1;
            for (std::vector<int>::size_type i = 0; i != mins.size(); i++) {
                auto rec = mins[i];
                auto & r = rec->strs;

                if (r.p < 0)
                {
                    const std::string prefix = rec->s;
                    const std::string suffix = r.s;

                    const std::string needle = prefix + n_s + suffix;

                    r.p = calc_start(needle) + length(prefix);
                }

                if (s(r.p, _clear_strs))
                {
                    clear_strs_ptr = &(rec->strs);
                    last_i = i;
                }
            }

            if (last_i == (ll)(mins.size())-1)
            {
                Mins * m = new Mins;
                m->s = std::to_string(next_mins++);
                mins.push_back(m);
            }
        }

        for ( auto start_new_pos : s_pos)
        {
            {
                auto & rec = mm[start_new_pos];

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
                //
                if (rec.p < 0)
                {
                    rec.p = _calc_mid_val(start_new_pos, rec.s);
                }
                if (s(
                    rec.p,
                    _clear_strs
                ))
                {
                    clear_strs_ptr = &rec;
                }
            }

            {
                auto & rec = mm_all_9s[start_new_pos];

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
                if (rec.p < 0)
                {
                    rec.p = _calc_mid_val(start_new_pos, std::string(rec.c, '9'));
                }
                if (s(
                        rec.p,
                        _clear_all_9s
                ))
                {
                    all_9s_start_new_pos = start_new_pos;
                }
            }
        }

        if (is_count_9s)
        {
            while (c9_pos < 0)
            {
                auto c9 = count_9s_base + std::string(count_9s, '0');
                ll c9_minus_1 = std::stoll(c9) - 1;
                std::string c9_minus_1_s = std::to_string(c9_minus_1);
                std::string both = c9_minus_1_s + c9;
                ll offset = length(c9_minus_1_s) - c9_count_9s_in_n;
                if (both.substr(offset, n_len) == n_s)
                {
                    c9_pos = calc_start(c9_minus_1) + offset;
                    break;
                }
                else
                {
                    count_9s++;
                }
            }
            s(c9_pos, _c9_cl);
        }

        cl();
        if (min > last_pos)
        {
            if (verbose || (count == MAX_COUNT))
            {
                std::cout << min << std::endl;
            }
            count++;
            last_pos = min;
        }
    }

    return 0;
}
