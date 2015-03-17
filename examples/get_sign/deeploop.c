/*
 * First KLEE tutorial: testing a small function
 */

#include <klee/klee.h>

int get_sign(int x) {
  int y = 1;
  while (x > 0) {
    y*=2;
    if(y==8)
      return 0;
    x--;
  }
   return 1;
} 

int main() {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  return get_sign(a);
} 
