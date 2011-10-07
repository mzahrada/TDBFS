class Node
	attr_accessor :id, :state, :siblings
	def initialize(id, state, siblings)
		@id = id
		@state = state				# for symbols :fresh / :opened / :closed
		@siblings =  siblings	# list of siblings = list of references to node objects!!!
	end
	def to_s
		return "#{id}-#{state}"
	end
end

class Graph
	attr_accessor :nodes
	def initialize(nodes)
		@nodes = nodes
	end
	public
		def getNode(id)
			for node in nodes
				if node.id == id 
					return node
				end
			end
		end 
		def makeNodesFresh()
			for node in nodes
				node.state = :fresh
			end
		end
		def to_s
			result = ""
			for node in nodes 
				result += "#{node.to_s} "
			end 
			return result
		end
end


# dfs - recursive
def dfs1(graph, node)
	result = []	
	dfs(graph, node, result)
	graph.makeNodesFresh
	return result.join(" ")
end

def dfs(graph, node, result)
	node.state = :opened
	result << node.id
	for sibling in node.siblings
		if(sibling.state == :fresh)
			dfs(graph, sibling, result)
		end
	end
	node.state = :closed
end


# dfs - while loop
def dfs2(graph, root)
	stack = [root]
	result = []
	while node = stack.pop()
		if (node.state == :fresh)		
			result << node.id 
		end
		node.state = :opened
		for sibling in node.siblings.reverse
			if (sibling.state == :fresh) 
				stack.push(sibling) 
			end
		end
	end
	graph.makeNodesFresh
	return result.join(" ")
end


def bfs(graph, root)
	queue = [root]
	root.state = :opened
	result = []
	while node = queue.shift()
		result << node.id
		for sibling in node.siblings
			if sibling.state == :fresh
				queue.push(sibling)
				sibling.state = :opened
			end
		end
	end
	graph.makeNodesFresh
	return result.join(" ")
end


# --- main ----
graphSum = gets.to_i
graphCount = 0
graphList = []	

while graphCount < graphSum
	graphNodes = []

	graphCount += 1
	puts "graph #{graphCount}"
	
	vertexCount = gets.to_i
	verticesHash = Hash.new

	1.upto(vertexCount) { |j| 
		splitted = gets.chomp.split(" ")
		nodeSiblings = Array.new
		2.upto(splitted[1].to_i+1) { |i| 
			if verticesHash[splitted[i].to_i] == nil
				node = Node.new(splitted[i].to_i, :fresh, nil) 
				nodeSiblings << node
				graphNodes << node
				verticesHash.store(splitted[i].to_i, node)
			else
				nodeSiblings << verticesHash[splitted[i].to_i]
			end
		}
		if verticesHash[j] == nil
			node = Node.new(j, :fresh, nodeSiblings)
			verticesHash.store(j, node)
			graphNodes << node
		else
			verticesHash[j].siblings = nodeSiblings 
		end
	}
	
	graphList << Graph.new(graphNodes)

	until (splitted = gets.chomp.split(" ")) == ["0","0"] 
		graph = graphList[graphCount-1]
		rootNode = graph.getNode(splitted[0].to_i)
		if splitted[1].to_i == 1 
			puts bfs(graph, rootNode)
		else 
			puts dfs1(graph, rootNode)		# recursive
			#puts dfs2(graph, rootNode)	# while loop	
		end
	end
end

