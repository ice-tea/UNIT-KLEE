/*
 * First KLEE tutorial: testing two input
 */

#include <klee/klee.h>


struct node{
	int key;
	struct node* next;
};

int get_sign(struct node* n) {
  if (n->key > n->next->key)
     return 0;
  
  if (n->key < n->next->key)
     return -1;
  else 
     return 1;
} 

int main() {
  struct node node1,node2;
  node1.next = &node2;
  node2.next = NULL;
  
  klee_make_symbolic(&node1, sizeof(node1), "node1");
  return get_sign(&node1);
} 
