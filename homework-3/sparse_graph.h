#ifndef _SPARSE_GRAPH_H
#define _SPARSE_GRAPH_H

#include "graph.h"
#include <vector>

class SparseGraph : public Graph {
 public:
  explicit SparseGraph(int n);

  void AddEdge(int source, int sink, double weight);
  double GetEdgeWeight(int source, int sink) const;

 private:
  std::vector< std::vector< std::pair< int, double > > > adj_list_;
};

#endif

