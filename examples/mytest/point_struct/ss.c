/*
 * First KLEE tutorial: testing two input
 */


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

int main() {
  structA s;
  f sp = &s;
   return  get_sign(sp);
} 
