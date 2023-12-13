#ifndef __PAIR_H__
#define __PAIR_H__

#include <stddef.h>
#include <stdint.h>


typedef struct pair_s {
	int first;
	int second;
} pair;


pair* new_pair(void);

pair* make_pair(int, int);

int get_first(pair*);

int get_second(pair*);

// Returns 1 if both pairs are equal, 0 otherwise.
int are_they_equal_pairs(pair*, pair*);

void print_pair(pair*);

#endif // __PAIR_H__
