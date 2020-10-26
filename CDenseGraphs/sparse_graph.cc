#include "sparse_graph.h"
#include <limits>
#include <vector>
#include <iostream>
#include <stdlib.h>

SparseGraph::SparseGraph(int num_nodes) : Graph(num_nodes) {

	adj_list_.resize(num_nodes);

};

  void SparseGraph::AddEdge(int source, int sink, double weight){

	  // ADD ERROR FOR NEGATIVE EDGE WEIGHT and SOURCE OUT OF BOUNDS

if (GetEdgeWeight(source,sink) != std::numeric_limits<double>::infinity() ){


	for (auto pair : adj_list_[source]){

		if (sink == pair.first)
pair.second = weight;

	}


}

else{
adj_list_[source].push_back({sink,weight});

}

  };

  double SparseGraph::GetEdgeWeight(int source, int sink) const{
// IF EDGE OUT OF BOUNDS GIVE ERROR	 
for (auto pair: adj_list_[source]){

if (sink == pair.first)
	return pair.second;

}

return std::numeric_limits<double>::infinity();

  };


