using StaticArrays
using LinearAlgebra

MAX_LATTICE_POINTS = 7

#Initial A matrix and b vector for the start of the construction
initial_A_matrix = -1 * I(3)
initial_b_vector = Vector{Int}([0, 0, 0])

#Library of Smooth Polygons, to be imported
Smooth_Polygon_Set = Set([[[0, 0], [0, 1], [1, 1], [1, 0]], [[0, 0], [0, 1], [1, 0]]])


#=
#A struct encoding a facet normal. 
#It should know the vertices lying on the facet
#struct Facet_Normal 
#	dual_vect::Vector{SVector{3, Int}}
#end
=#

#A struct encoding a vertex. It should know its neighbors and relevant facet normals
struct Vertex
	coordinates::SVector{3, Int}
	neighbors::Set{Int}
	#facet_normal_indices::Set{Int}
end

function print_info(vertices::Vector{Vertex}, A_matrix, b_vector, uninserted_facets_indices)
	println("The polytope's vertices are")
	for vertex in vertices
		println(vertex.coordinates)
	end
	println("While its Ax <= b data is given by")
	println(A_matrix)
	println(b_vector)
	println("The following facet indices have yet to be inserted")
	println(uninserted_facets_indices)
end

#When embedding a new face, we want to query our database for all possible smooth polygons that would fit into the face. 
#This should return all possible smooth polygons that have those points
######
#	query_Polygon_DB([[0, 0], [0, 1], [1, 0]])
#	[[[0, 0], [0, 1], [1, 0]], [[0, 0], [0, 1], [1, 1], [1, 0]]]
#		(should return the 2-simplex and the Square)
######
#Placeholder until I implement the database prefix trie

###Test
#example_points = Set([[0, 0], [0, 1], [1, 0]])
#println(query_Polygon_Set(example_points))
function query_Polygon_Set(points::Set{Vector{Int64}})
	polytopes = Set{Vector{Vector{Int64}}}()
	for polytope in Smooth_Polygon_Set
		if issubset(points, Set(polytope)) #converts the vector to a set, to check if the points are a subset
			push!(polytopes, polytope)
		end
	end
	return polytopes
end 

function initialize_seed(x_length, y_length, z_length)
    vertices = [
        Vertex(SVector(0, 0, 0), Set{Int}([2, 3, 4])),
        Vertex(SVector(x_length, 0, 0), Set{Int}([1])),
        Vertex(SVector(0, y_length, 0), Set{Int}([1])),
        Vertex(SVector(0, 0, z_length), Set{Int}([1]))
    ]
	A_matrix = initial_A_matrix
	b_vector = initial_b_vector
	uninserted_facets_indices = Set{Int}([1, 2, 3])
	build_polytopes(vertices, A_matrix, b_vector, uninserted_facets_indices)
end

function build_polytopes(vertices::Vector{Vertex}, A_matrix, b_vector, uninserted_facets_indices)
	print_info(vertices, A_matrix, b_vector, uninserted_facets_indices)
end

#Building the initial seed of the faces meeting the origin
for x_length in 1:MAX_LATTICE_POINTS, y_length in 1:min(MAX_LATTICE_POINTS-x_length, x_length), z_length in 1:min(MAX_LATTICE_POINTS-x_length-y_length, y_length)
	#We can assume all lengths are <= x_length, by symmetry
	
	initialize_seed(x_length, y_length, z_length)
end