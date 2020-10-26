#include "dense_graph.h"
#include <limits>
#include <vector>
#include <iostream>
#include <stdlib.h>

DenseGraph::DenseGraph(int num_nodes) : Graph(num_nodes) {

adj_matrix_ = (double**) malloc(sizeof(double*) * num_nodes_);

for (int i = 0; i < num_nodes_; i++)
adj_matrix_[i] = (double*) malloc(sizeof(double) * num_nodes_);

for (int i = 0; i < num_nodes_; i++){

for (int j = 0; j < num_nodes_; j++)
adj_matrix_[i][j] = std::numeric_limits<double>::infinity();

}

};

// Copy Constructor

DenseGraph::DenseGraph(const DenseGraph& copy_from) : Graph(copy_from.num_nodes_) {

adj_matrix_ = (double**) malloc(sizeof(double*) * num_nodes_);

for (int i = 0; i < num_nodes_; i++)
adj_matrix_[i] = (double*) malloc(sizeof(double) * num_nodes_);

for (int i = 0; i < num_nodes_; i++){

for (int j = 0; j < num_nodes_; j++)
adj_matrix_[i][j] = copy_from.adj_matrix_[i][j];

}

};

// Destructor
DenseGraph::~DenseGraph() {

	for (int i = 0; i < num_nodes_; i++)
	free(adj_matrix_[i]);
	
	free(adj_matrix_);

}

// Copy Assignment Operator


DenseGraph& DenseGraph::operator=(const DenseGraph& copy_from){

for (int i = 0; i < num_nodes_; i++)
free(adj_matrix_[i]);

free(adj_matrix_);

num_nodes_ = copy_from.num_nodes_;

adj_matrix_ = (double**) malloc(sizeof(double*) * num_nodes_);

for (int i = 0; i < num_nodes_; i++)
adj_matrix_[i] = (double*) malloc(sizeof(double) * num_nodes_);

for (int i = 0; i < num_nodes_; i++){

for (int j = 0; j < num_nodes_; j++)
adj_matrix_[i][j] = copy_from.adj_matrix_[i][j];

}


return *this;	  
  };

  void DenseGraph::AddEdge(int source, int sink, double weight){

adj_matrix_[source][sink] = weight;

  };
  
double DenseGraph::GetEdgeWeight(int source, int sink) const{

return adj_matrix_[source][sink];

};
