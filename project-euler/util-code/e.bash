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
