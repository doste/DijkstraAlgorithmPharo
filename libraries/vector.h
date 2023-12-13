#ifndef __VECTOR_H__
#define __VECTOR_H__

#include <stddef.h>
#include <stdint.h>


typedef struct vector_s {
	uint64_t size;	
    uint64_t capacity;
	uint32_t* array;
} vector_t;


vector_t* new_vector(void);

uint64_t get_size(vector_t*);

void push_back(vector_t*, uint32_t);

uint32_t get_at(vector_t*, size_t);

void set_at(vector_t* vector, size_t, int);

int are_they_equal(vector_t*, vector_t*);

vector_t* init_with_value(int, int);

void assign(vector_t*, size_t, int);

void print_vector(vector_t*);

#endif // __VECTOR_H__
