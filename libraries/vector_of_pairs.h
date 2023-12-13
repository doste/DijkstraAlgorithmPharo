#ifndef __VECTOR_OF_PAIRS_H__
#define __VECTOR_OF_PAIRS_H__

#include "pair.h"
#include <stddef.h>
#include <stdint.h>


typedef struct vector_p {
	uint64_t size;	
    uint64_t capacity;
	pair* array;
} vector_of_pairs;


vector_of_pairs* new_vector_of_pairs(void);

uint64_t get_size_vp(vector_of_pairs*);

void push_back_vp(vector_of_pairs*, pair);

pair* get_at_vp(vector_of_pairs*, size_t);

void set_at_vp(vector_of_pairs* vector, size_t, pair);



#endif // __VECTOR_OF_PAIRS_H__
