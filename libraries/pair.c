#include "pair.h"
#include <stdlib.h>
#include <stdio.h>


pair* new_pair(void) {
    pair* p = calloc(1, sizeof(pair));
    return p;
}

pair* make_pair(int f, int s) {
    pair* p = calloc(1, sizeof(pair));
    p->first = f;
    p->second = s;
    return p;
}

int get_first(pair* p) {
    return p->first;
}

int get_second(pair* p) {
    return p->second;
}

int are_they_equal_pairs(pair* p1, pair* p2) {
    if (p1->first == p2->first && p1->second == p2->second) {
        return 1;
    }
    return 0;
}

void print_pair(pair* p) {
    printf("first: %d . second: %d\n", p->first, p->second);
}
