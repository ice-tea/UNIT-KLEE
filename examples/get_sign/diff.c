/*
 * First KLEE tutorial: testing a small function
 */

#include <klee/klee.h>

int get_sign(int x,int y) {
  if (x <y )
     return 0;
  else{
  if(x==y)
     return 1;
  else 
     return -1;
  }
} 

int main() {
  int a;
  int b;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_make_symbolic(&b, sizeof(b), "b");
  return get_sign(a,b);
} 
