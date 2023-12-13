#include "vector.h"
#include "pair.h"
#include "vector_of_pairs.h"
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

//vector<vector<pair<int, int>>> adj;
typedef struct slice {
	uint64_t size;	
    vector_of_pairs** ptr;
} Slice;

Slice* adj;

const int INF = INT_MAX;

int return_infinity(void) {
    return INF;
}

void dijkstra(int s, vector_t* distances, vector_t* parent) {
    //int n = adj.size();
    int n = adj->size;

    //d.assign(n, INF);
    assign(distances, n, INF);

    //p.assign(n, -1);
    assign(parent, n, -1);

    //vector<bool> u(n, false);
    vector_t* marked = init_with_value(n, 0);

    //d[s] = 0;
    set_at(distances, s, 0);

    for (int i = 0; i < n; i++) {
        int v = -1;
        for (int j = 0; j < n; j++) {
            //if (!u[j] && (v == -1 || d[j] < d[v]))
            if (get_at(marked, j) == 0) {
                if (v == -1 || get_at(distances, j) < get_at(distances, v)) {
                    v = j;
                }
            }
        }

        //if (d[v] == INF)
        if (get_at(distances, v) == INF)
            break;

        //u[v] = true;
        set_at(marked, v, 1);

        // for (auto edge : adj[v]) {
        for (int k = 0; k < get_size_vp(adj->ptr[v]); k++) {

            pair* edge = get_at_vp(adj->ptr[v], k);

            int to = edge->first;
            int len = edge->second;

            //if (d[v] + len < d[to]) {
            if (get_at(distances, v) + len < get_at(distances, to)) {
                //d[to] = d[v] + len;
                set_at(distances, to, get_at(distances, v) + len);
                //p[to] = v;
                set_at(parent, to, v);
            }
        }
        
    }
}

void print_vector_to_file(FILE* fp, vector_t* vector) {
    for (int i = 0; i < get_size(vector); i++) {
        fprintf(fp, "%d\n", get_at(vector, i));
    }
    fprintf(fp, "\n");
}

void run_dijkstra(void) {

    int cant_vertices, first, second, cant_tuplas;
    pair* p;

    FILE* fp_in;
    FILE* fp_out;

    char* input_path = "/Users/juanidoste/Documents/Pharo/images/Pharo 11.0 - 64bit (stable)/inputFromPharo.txt";
    //if ((fp_in = fopen("input.txt", "r")) == NULL) {
    if ((fp_in = fopen(input_path, "r")) == NULL) {
        puts("input.txt doesn't exist!\n");
        exit(1);
    }

    char* output_path = "/Users/juanidoste/Documents/Pharo/images/Pharo 11.0 - 64bit (stable)/outputFromC.txt";
    //if ((fp_out = fopen("output.txt", "w")) == NULL) {
    if ((fp_out = fopen(output_path, "w")) == NULL) {
        puts("output.txt doesn't exist!\n");
        exit(1);
    }
    
    fscanf(fp_in, "%d", &cant_vertices);

    adj = malloc(sizeof(Slice));
    adj->ptr = malloc(cant_vertices * sizeof(vector_of_pairs));
    adj->size = cant_vertices;

    for (int i = 0; i < cant_vertices; i++) {

        fscanf(fp_in, "%d", &cant_tuplas);
        
        adj->ptr[i] = new_vector_of_pairs();

        for (int j = 0; j < cant_tuplas; j++) {
            
            //cin >> first >> second;
            fscanf(fp_in, "%d", &first);
            fscanf(fp_in, "%d", &second);

            p = make_pair(first, second);

            push_back_vp(adj->ptr[i], *p);
        }
    }

    //vector<int> distances = vector<int>(cant_vertices, 0);
    vector_t* distances = init_with_value(cant_vertices, 0);

    //vector<int> parent = vector<int>(cant_vertices, 0);
    vector_t* parent = init_with_value(cant_vertices, 0);

    dijkstra(0, distances, parent);

    fprintf(fp_out, "D\n");
    print_vector_to_file(fp_out, distances);

    fprintf(fp_out, "P\n");
    print_vector_to_file(fp_out, parent);


    fclose(fp_in);
    fclose(fp_out);
    //return 17;
}

/*
int main(int argc, char** argv) {
  
    run_dijkstra();
}
*/