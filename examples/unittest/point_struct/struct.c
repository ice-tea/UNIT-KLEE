/*
 * First KLEE tutorial: testing two input
 */

#include <klee/klee.h>


typedef struct first{
	int a;
	int b;
} structA;
typedef structA * f;

int get_sign(f s) {
  if (s->a > s->b)
     return 0;
  
  if (s->a < s->b)
     return -1;
  else 
     return 1;
}
int get_sign2(structA s) {
  if (s.a > s.b)
     return 0;
  
  if (s.a < s.b)
     return -1;
  else 
     return 1;
} 

int main() {
  structA s;
  f sp = &s;
  //klee_make_symbolic(&s, sizeof(s),"s");
  klee_define_fixed_object(sp,8);
  //klee_make_symbolic(sp, sizeof(s), "sp");
  return get_sign(sp);
} 
