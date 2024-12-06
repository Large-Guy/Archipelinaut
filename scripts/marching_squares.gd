extends StaticBody2D

@export var tile_size: float = 64
@export var size: int = 16

var tiles: PackedInt32Array

var collision_polygons: Array[CollisionPolygon2D]
var meshs: Array[MeshInstance2D]

var st: SurfaceTool

var vertices: Array[Vector2]
var indices: Array[int]
var edges: Array = []
var edge_groups: Array = []
var edge_points: Array = []

var cases: Dictionary = {
	[false,false,false,false]:[], # 0 Empty
	[false,false,true,false]:[Vector2(0,0.5),Vector2(0,1),Vector2(0.5,1)], # 1 Bottom Left
	[false,false,false,true]:[Vector2(1,0.5),Vector2(0.5,1),Vector2(1,1)], # 2 Bottom Right
	[false,false,true,true]:[Vector2(0,0.5),Vector2(0,1),Vector2(1,1),Vector2(1,0.5),Vector2(0,0.5),Vector2(1,1)], # 3 Bottom Half
	[false,true,false,false]:[Vector2(0.5,0),Vector2(1,0.5),Vector2(1,0)], # 4 Top Right
	[false,true,true,false]:[Vector2(0.5,0),Vector2(0,0.5),Vector2(0,1),Vector2(1,0.5),Vector2(0,1),Vector2(0.5,1),Vector2(1,0),Vector2(0.5,0),Vector2(0,1),Vector2(1,0),Vector2(0,1),Vector2(1,0.5)], # 5 Bottom Left, Top Right
	[false,true,false,true]:[Vector2(0.5,0),Vector2(0.5,1),Vector2(1,1),Vector2(0.5,0),Vector2(1,1),Vector2(1,0)], # 6 Right
	[false,true,true,true]:[Vector2(0,0.5),Vector2(0,1),Vector2(1,1),Vector2(0.5,0),Vector2(0,0.5),Vector2(1,1),Vector2(0.5,0),Vector2(1,1),Vector2(1,0)], # 7 Bottom and Right
	[true,false,false,false]:[Vector2(0,0),Vector2(0,0.5),Vector2(0.5,0)], # 8 Top Left
	[true,false,true,false]:[Vector2(0,0),Vector2(0,1),Vector2(0.5,1),Vector2(0,0),Vector2(0.5,1),Vector2(0.5,0)], # 9 Left
	[true,false,false,true]:[Vector2(0,0),Vector2(0,0.5),Vector2(0.5,1),Vector2(0,0),Vector2(0.5,1),Vector2(1,1),Vector2(0,0),Vector2(1,1),Vector2(1,0.5),Vector2(0,0),Vector2(1,0.5),Vector2(0.5,0)], # 10 Top Left, Bottom Right
	[true,false,true,true]:[Vector2(0,0),Vector2(0,1),Vector2(0.5,0),Vector2(0.5,0),Vector2(0,1),Vector2(1,0.5),Vector2(1,0.5),Vector2(0,1),Vector2(1,1)], # 11 Bottom and Left
	[true,true,false,false]:[Vector2(0,0),Vector2(0,0.5),Vector2(1,0.5),Vector2(0,0),Vector2(1,0.5),Vector2(1,0)], # 12 Top
	[true,true,true,false]:[Vector2(0,0),Vector2(1,0.5),Vector2(1,0),Vector2(0,0),Vector2(0.5,1),Vector2(1,0.5),Vector2(0,0),Vector2(0,1),Vector2(0.5,1)], # 13 Top and Left
	[true,true,false,true]:[Vector2(0,0),Vector2(0,0.5),Vector2(1,0),Vector2(0,0.5),Vector2(0.5,1),Vector2(1,0),Vector2(0.5,1),Vector2(1,1),Vector2(1,0)], # 14 Top and Right
	[true,true,true,true]:[Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(1,0),Vector2(0,1),Vector2(1,1)] # 15 All
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tiles.resize((size+1)*(size+1))

	_clear()

	generate()

func _clear():
	for y in range(size+1):
		for x in range(size+1):
			set_tile(Vector2i(x,y),-1)

func insert_case(pos: Vector2,c: Array[bool]):
	var case: Array = cases[c]

	var i = 0
	var s = vertices.size()
	for vertex: Vector2 in case:
		var vert = vertex
		vert += pos
		vertices.append(vert)
		indices.append(s + i)

		i += 1

func tile_filled(x:int,y:int,i:int = 0) -> bool:
	if(x < 0): return false
	if(x >= size+1): return false
	if(y < 0): return false
	if(y >= size+1): return false

	if i == -1: return tiles[y * (size+1) + x] >= 0
	else: return tiles[y * (size+1) + x] == i

func tile_edging(x:int,y:int) -> bool:
	if !tile_filled(x,y): return false

	if !tile_filled(x,y-1): return true
	if !tile_filled(x - 1, y): return true
	if !tile_filled(x+1,y): return true
	if !tile_filled(x,y+1): return true
	return false

func set_tile(pos: Vector2i,t:int) -> void:
	var x = pos.x
	var y = pos.y
	if(x < 0):
		return
	if(x >= size+1):
		return
	if(y < 0):
		return
	if(y >= size+1):
		return

	tiles[y * (size+1) + x] = t

func get_tile(pos: Vector2i) -> int:
	var x = pos.x
	var y = pos.y
	if(x < 0):
		return 0
	if(x >= size+1):
		return 0
	if(y < 0):
		return 0
	if(y >= size+1):
		return 0

	return tiles[y * (size+1) + x]

func generate():

	var tiles_used = {}

	for y in range(size+1):
		for x in range(size+1):
			if(tiles[y*(size+1)+x] >= 0):
				tiles_used[tiles[y * (size + 1) + x]] = null

	if meshs.size() > tiles_used.size():
		while tiles_used.size() < meshs.size():
			meshs[tiles_used.size()].queue_free()
			meshs.remove_at(tiles_used.size())

	while(meshs.size() < tiles_used.size()):
		var mesh: MeshInstance2D = MeshInstance2D.new()
		add_child(mesh)
		meshs.append(mesh)

	var i: int = 0

	for key in tiles_used:
		vertices.clear()
		indices.clear()

		meshs[i].mesh = generate_mesh(key)
		meshs[i].z_index = -4096 + 20
		meshs[i].modulate = Tile.tiles[key].color
		i += 1

	vertices.clear()
	indices.clear()
	generate_mesh(-1)
	#generate_collision()

func generate_mesh(i: int) -> ArrayMesh:
	for y in range(1,size+1):
		for x in range(1,size+1):
			var tl = tile_filled(x-1,y-1,i)
			var tr = tile_filled(x,y-1,i)
			var bl = tile_filled(x-1,y,i)
			var br = tile_filled(x,y,i)

			insert_case(Vector2(x-1,y-1),[tl,tr,bl,br])

	optimize_mesh()

	st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for vertex in vertices:
		st.add_vertex(Vector3(vertex.x,vertex.y,0.0) * tile_size)

	for index in indices:
		st.add_index(index)

	return st.commit()

func generate_collision():
	# First we need to get the edges of every triangle in the mesh
	var triangle_edges = {}

	for t in range(0,indices.size(),3):
		var triA = [indices[t], indices[t+1]]
		triA.sort()

		if(!triangle_edges.has(triA)):
			triangle_edges[triA] = 1
		else:
			triangle_edges[triA] += 1

		var triB = [indices[t+1], indices[t+2]]
		triB.sort()

		if(!triangle_edges.has(triB)):
			triangle_edges[triB] = 1
		else:
			triangle_edges[triB] += 1

		var triC = [indices[t+2], indices[t]]
		triC.sort()

		if(!triangle_edges.has(triC)):
			triangle_edges[triC] = 1
		else:
			triangle_edges[triC] += 1

	# clear the edges from the last frame
	edges.clear()

	# filter out only the edges that appear once (edging edges)
	for key in triangle_edges:
		if(triangle_edges[key] == 1):
			edges.append(key)


	#group them together
	edge_groups.clear()

	edge_groups = group_edges_into_shapes()

	order_edges()

	if collision_polygons.size() > edge_groups.size():
		while edge_groups.size() < collision_polygons.size():
			collision_polygons[edge_groups.size()].queue_free()
			collision_polygons.remove_at(edge_groups.size())

	while(collision_polygons.size() < edge_groups.size()):
		var col = CollisionPolygon2D.new()
		col.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
		add_child(col)
		collision_polygons.append(col)

	var i: int = 0
	for group in edge_points:
		collision_polygons[i].polygon = PackedVector2Array(group)
		i += 1

func optimize_mesh():
	var unique_vertices = {}
	var optimized_vertices: Array[Vector2] = []
	var optimized_indices: Array[int] = []

	for index in indices:
		var vertex = vertices[index]

		if unique_vertices.has(vertex):
			optimized_indices.append(unique_vertices[vertex])
		else:
			var new_index = optimized_vertices.size()
			unique_vertices[vertex] = new_index
			optimized_vertices.append(vertex)
			optimized_indices.append(new_index)

	vertices = optimized_vertices
	indices = optimized_indices

func vertex_full_edging(v: Vector2) -> bool:
	if !vertices.has(v + Vector2(1.0,0)): return true
	if !vertices.has(v + Vector2(-1.0,0)): return true
	if !vertices.has(v + Vector2(0,1.0)): return true
	if !vertices.has(v + Vector2(0,-1.0)): return true
	return false

func vertex_half_edging(v: Vector2) -> bool:
	if !vertices.has(v + Vector2(0.5,0)): return true
	if !vertices.has(v + Vector2(-0.5,0)): return true
	if !vertices.has(v + Vector2(0,0.5)): return true
	if !vertices.has(v + Vector2(0,-0.5)): return true
	return false

func world_to_tile(pos: Vector2) -> Vector2i:
	pos -= global_position
	var p = Vector2i(pos)/tile_size

	return p

# Function to group edges into shapes
func group_edges_into_shapes() -> Array:
	# Create a copy of edges to track unprocessed edges
	var remaining_edges = edges.duplicate()
	var edge_groups = []

	while remaining_edges.size() > 0:
		# Start a new shape with the first remaining edge
		var current_shape = []
		var current_edge = remaining_edges.pop_back()
		current_shape.append(current_edge)

		# Build the shape by connecting edges
		var open_nodes = [current_edge[0], current_edge[1]]  # Nodes at the edge of the current shape
		while open_nodes.size() > 0:
			var next_node = open_nodes.pop_back()

			# Find a connecting edge
			for i in range(remaining_edges.size()):
				var edge = remaining_edges[i]
				if next_node in edge:
					# Add the edge to the shape
					current_shape.append(edge)
					remaining_edges.remove_at(i)

					# Add the new open node(s) to the list
					if edge[0] == next_node:
						open_nodes.append(edge[1])
					elif edge[1] == next_node:
						open_nodes.append(edge[0])
					break

		# Add the completed shape to the edge groups
		edge_groups.append(current_shape)

	return edge_groups

func random(seed: int) -> float:
	return (sin(cos(sin(float(seed) * 2491.234857893)*34570934.23457394)*3489579.217490) + 1)/2

func _draw() -> void:
	pass
	#draw_line(Vector2(0,0),Vector2(size * tile_size,0),Color.RED)
	#draw_line(Vector2(size * tile_size,0),Vector2(size * tile_size,size * tile_size),Color.RED)
	#draw_line(Vector2(0,0),Vector2(0,size * tile_size),Color.RED)
	#draw_line(Vector2(0,size * tile_size),Vector2(size * tile_size,size * tile_size),Color.RED)

func order_edges():
	# Final processing step, sort the points to go in a circle
	edge_points.clear()

	for i in range(edge_groups.size()):
		var edges: Array = edge_groups[i]

		# Map to track connections for each vertex
		var connections = {}
		for edge in edges:
			if not connections.has(edge[0]):
				connections[edge[0]] = []
			if not connections.has(edge[1]):
				connections[edge[1]] = []
			connections[edge[0]].append(edge[1])
			connections[edge[1]].append(edge[0])

		# Start traversal
		var visited_edges = {}
		var ordered_points = []
		var current_edge = edges[0]  # Start with any edge
		var start_point = current_edge[0]
		var current_point = current_edge[0]
		var previous_point = null

		ordered_points.append(current_point)

		while true:
			var neighbors = connections[current_point]

			# Find the next point that hasn’t been visited
			var next_point = null
			for neighbor in neighbors:
				if neighbor != previous_point:
					next_point = neighbor
					break

			if next_point == null or next_point == start_point:
				break  # Either completed the loop or no further connections

			# Add to ordered points
			ordered_points.append(next_point)

			# Update traversal variables
			previous_point = current_point
			current_point = next_point

		# Add the ordered points to edge_points
		edge_points.append([])

		for p in ordered_points:
			edge_points.back().append(vertices[p])
