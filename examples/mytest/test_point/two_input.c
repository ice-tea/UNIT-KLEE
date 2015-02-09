/*
 * First KLEE tutorial: testing two input
 */

#include <klee/klee.h>

int get_sign(int *x) {
  if (*x > 0)
     return 0;
  
  if (*x < 0)
     return -1;
  else 
     return 1;
} 

int main() {
  int a;
  int *p =&a;
  //klee_make_symbolic(&p, sizeof(p), "p");
  //klee_make_symbolic(p,sizeof(int),"p");
  return get_sign(p);
} 
