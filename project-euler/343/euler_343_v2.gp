/* Taken from https://projecteuler.net/thread=343 */
{
    s=1;
    for(k=2,2000000,
        a=factor(k+1)[,1]; p=a[#a];
        a=factor(k*k-k+1)[,1]; q=a[#a];
        s+=if(p>q,p,q)-1;
    );
    print(s);
}
