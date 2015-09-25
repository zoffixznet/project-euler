/*
 * Taken from:
 *
 * https://mukeshiiitm.wordpress.com/2010/04/25/project-euler-problem-266/
 *
 * */

#include<cstdio>
#include<iostream>
#include<gmpxx.h>
#include<vector>
#include<algorithm>
#include<ctime>

using namespace std;
vector<mpz_class> v,v_l,v_r;
mpz_class ret;

void _prime()
    {
        bool p[190];
        memset(p,0,sizeof p);
        for(int i=2;i*i<190;i++)
            if(!p[i])
                for(int j=i*i;j<190;j+=i) p[j]=1;
        mpz_class cnt=1;
        for(int j=2;j<190;j++) if(!p[j]) cnt*=j,v.push_back(mpz_class(j));
        //cout<<endl;
        //cout<<cnt<<" "<<sqrt(cnt)<<" "<<v.size()<<endl;
        ret=sqrt(cnt);
        //cout<<ret*ret<<" "<<cnt<<endl;
    }

int main()
    {
        clock_t start,end;
        double rutime;
        start=clock();
        _prime();
        for(int i=0;i<(1<<21);i++)
        {
            mpz_class t_1=1,t_2=1;
            for(int j=0;j<21;j++) if(i&(1<<j))t_1*=v[j],t_2*=v[j+21];
            v_l.push_back(t_1);
            v_r.push_back(t_2);
        }


        sort(v_l.begin(),v_l.end());
        sort(v_r.begin(),v_r.end());
        //cout<<v_l.size()<<v_r.size()<<endl;
        //for(int i=0;i<10;i++) cout<<v[i]<<endl;
        mpz_class m=0;
        for(int i=0;i<v_l.size();i++)
        {
            mpz_class k=*(upper_bound(v_r.begin(),v_r.end(),ret/v_l[i])-1);
            if(m<(k*v_l[i]))m=k*v_l[i];
        }
        cout<<m<<endl;
        end=clock();
        rutime=((end-start)/(double)CLOCKS_PER_SEC);
        cout<<"runtime is "<<rutime<<endl;
    }
