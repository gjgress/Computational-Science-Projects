# Targets

lib: graph.cc sparse_graph.cc dense_graph.cc
	g++ -c graph.cc sparse_graph.cc dense_graph.cc test.cc
	ar -rs libgraph.a graph.o sparse_graph.o dense_graph.o

test: libgraph.a test.cc
	g++ -o runtest test.cc libgraph.a

clean: *.o *.a
	rm *.o *.a runtest
