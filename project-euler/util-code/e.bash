# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
a()
{
    fn="$1"
    gvim -f "$fn" && git add "$fn"
}
b()
{
    a "euler-$1-description.txt"
}
alias gs='git st -s'
