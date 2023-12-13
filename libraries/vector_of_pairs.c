#include "vector_of_pairs.h"
#include "pair.h"
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <assert.h>


vector_of_pairs* new_vector_of_pairs(void) {
	vector_of_pairs* nuevo_vector_creado = malloc(sizeof(vector_of_pairs));
    nuevo_vector_creado->capacity = 2;
    nuevo_vector_creado->size = 0;

    nuevo_vector_creado->array = malloc(nuevo_vector_creado->capacity * sizeof(pair));

	return nuevo_vector_creado;
}

uint64_t get_size_vp(vector_of_pairs* vector) {
    return vector->size;
}

void push_back_vp(vector_of_pairs* vector, pair p) {
	if (vector->size + 1 > vector->capacity) {
        size_t new_capacity = 2 * vector->capacity;
        vector->array = realloc(vector->array, new_capacity * sizeof(pair));
        
        vector->capacity = new_capacity;
    }

    vector->array[vector->size] = p;
    vector->size++;
}

pair* get_at_vp(vector_of_pairs* vector, size_t index) {
	assert(index >= 0 && index < vector->size);
	return &vector->array[index];
}

void set_at_vp(vector_of_pairs* vector, size_t index, pair p) {
	assert(index >= 0 && index > index > vector->size);
	vector->array[index] = p;
}
