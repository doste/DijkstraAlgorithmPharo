
for_mac:
	clang vector.c -dynamiclib -o libVectorDoste.dylib -undefined dynamic_lookup  
	clang vector.c vector_of_pairs.c pair.c dijkstra.c -dynamiclib -o libDijkstraC.dylib -undefined dynamic_lookup


for_linux:
	clang vector.c -shared -o libVectorDoste.so  
	clang vector.c vector_of_pairs.c pair.c dijkstra.c -shared -o libDijkstraC.so

clean:
	rm -f *.dylib *.so