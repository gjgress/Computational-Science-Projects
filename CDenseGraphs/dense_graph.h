#ifndef _DENSE_GRAPH_H
#define _DENSE_GRAPH_H

#include "graph.h"

class DenseGraph : public Graph {
 public:
  explicit DenseGraph(int num_nodes);
  ~DenseGraph(void);

  DenseGraph(const DenseGraph& copy_from);
  DenseGraph& operator=(const DenseGraph& copy_from);

  void AddEdge(int source, int sink, double weight);
  double GetEdgeWeight(int source, int sink) const;

 private:
  double** adj_matrix_;
};

#endif

