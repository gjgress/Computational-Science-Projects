#include "graph.h"
#include <numeric>
#include <iostream>
#include <limits>
#include <vector>


Graph::Graph(int num_nodes) {
num_nodes_ = num_nodes;
}

std::vector<double> Graph::Dijkstra(int source) const{

std::vector<double> d;
d.resize(num_nodes_);

std::vector<bool> visited;
visited.resize(num_nodes_);

for (int i = 0; i < num_nodes_; i++){
d[i] = std::numeric_limits<double>::infinity();
visited[i] = 0;

}
d[source] = 0;

while (std::accumulate(visited.begin(),visited.end(),0) < num_nodes_){
double minval = std::numeric_limits<double>::infinity();
int minindex = -1;

	for (int i = 0; i < num_nodes_; i++){
		if (visited[i] == 0){
			if (d[i] <= minval){
			minval = d[i];
			minindex = i;
			}

}
}
visited[minindex] = 1;

	for (int j = 0; j < num_nodes_; j++){
		if (HasEdge(minindex,j)){
			if (d[j] > d[minindex] + GetEdgeWeight(minindex,j)){
				d[j] = d[minindex] + GetEdgeWeight(minindex,j);
				}
		}
}


}

return d;

};


int Graph::number_of_nodes(void) const {
return num_nodes_;
}
