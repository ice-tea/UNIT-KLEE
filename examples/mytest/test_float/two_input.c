/*
 * First KLEE tutorial: testing two input
 */

#include <klee/klee.h>

int get_sign(float a, float b) {
  if (a > b)
     return 0;
  else if (a == b)
     return 1;
  else 
     return 2;
}

int main() {
  float a,b;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_make_symbolic(&b, sizeof(b), "b");
  return get_sign(a,b);
}
