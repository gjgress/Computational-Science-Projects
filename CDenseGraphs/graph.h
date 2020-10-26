#ifndef _GRAPH_H
#define _GRAPH_H

#include <limits>
#include <vector>

class Graph {
 public:
  explicit Graph(int num_nodes);
  int number_of_nodes(void) const;

  virtual void AddEdge(int source, int sink, double weight) = 0;
  virtual double GetEdgeWeight(int source, int sink) const = 0;

  bool HasEdge(int source, int sink) const {
    return GetEdgeWeight(source, sink) < std::numeric_limits<double>::infinity();
  }

  std::vector<double> Dijkstra(int source) const;

 protected:
  int num_nodes_;
};

#endif

