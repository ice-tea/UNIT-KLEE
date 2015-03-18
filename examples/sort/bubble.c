#include <klee/klee.h>
#define MAXLEN 6

void bubble(int v[MAXLEN], int n)
{
   int i,j,k;
   if(n>=MAXLEN)
      return;
   for(i=n;i>1;--i)
     for(j=1;j<i;++j)
      if(v[j]>v[j+1])
      {
         k=v[j];
         v[j]=v[j+1];
         v[j+1]=k;
       }
}

int main() {
  int arr[MAXLEN];
  int len;

  klee_make_symbolic(&arr, sizeof(arr), "arr");
  klee_make_symbolic(&len, sizeof(len), "len");
  bubble(arr,len);

  return 0;
}