#include "vector.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


vector_t* new_vector(void) {
	vector_t* nuevo_vector_creado = malloc(sizeof(vector_t));
    nuevo_vector_creado->capacity = 2;
    nuevo_vector_creado->size = 0;

    uint32_t* array = malloc(nuevo_vector_creado->capacity * sizeof(uint32_t));
	nuevo_vector_creado->array = array;

	return nuevo_vector_creado;
}

uint64_t get_size(vector_t* vector) {
    return vector->size;
}

void push_back(vector_t* vector, uint32_t elemento) {
    if (vector->size + 1 > vector->capacity) {
        size_t new_capacity = 2 * vector->capacity;
        vector->array = realloc(vector->array, new_capacity * sizeof(uint32_t));
        
        vector->capacity = new_capacity;
    }

    vector->array[vector->size] = elemento;
    vector->size++;
}


int are_they_equal(vector_t* v1, vector_t* v2) {

    if (v1->size != v2->size) {
        return 0;
    }

    for (size_t i = 0; i < v1->size; i++) {
        if (get_at(v1, i) != get_at(v2, i)) {
            return 0;
        }
    }
    return 1;
}

uint32_t get_at(vector_t* vector, size_t index) {
    return vector->array[index];

}

void set_at(vector_t* vector, size_t index, int valor) {

    vector->array[index] = valor;

}



vector_t* init_with_value(int cuantos, int valor)
{   
    vector_t* nuevo_vector_creado = malloc(sizeof(vector_t));
    nuevo_vector_creado->capacity = cuantos;
    nuevo_vector_creado->size = cuantos;

    uint32_t* array = malloc(nuevo_vector_creado->capacity * sizeof(uint32_t));
	nuevo_vector_creado->array = array;

    for (size_t i = 0; i < cuantos; i++)
    {
        nuevo_vector_creado->array[i] = valor;
    }

	return nuevo_vector_creado;
}


void assign(vector_t* vector, size_t count, int value) {   
    free(vector->array);

    vector->array = malloc(count * sizeof(uint32_t));

    for (size_t i = 0; i < count; i++)
    {
        vector->array[i] = value;
    }
    vector->capacity = count;
    vector->size = count;
}


void print_vector(vector_t* v) {
    for (int i = 0; i < get_size(v); i++) {
        printf("%d : %d\n", i, get_at(v, i));
    }
    printf("\n");
}