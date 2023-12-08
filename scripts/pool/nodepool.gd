extends Node
class_name NodePool

var id : String
var node_path : String
var node_amount : int
var scene

func _init(identifier : String, path : String, amount : int):
	id = identifier
	node_path = path
	node_amount = amount
	scene = load(node_path)

func _ready():
	for i in node_amount:
		var instance = scene.instantiate()
		instance.process_mode = PROCESS_MODE_DISABLED
		add_child(instance)
		if instance is Node2D:
			instance.modulate.a = 0

func borrow_node(recipient : Node) -> Node:
	if get_child_count() == 0:
		return null
	
	var node = get_child(0)
	remove_child(node)
	recipient.add_child(node)
	node.process_mode = Node.PROCESS_MODE_INHERIT
	
	if node is Node2D:
		node.modulate.a = 1
	
	if node.has_method("_borrow"):
		node.call("_borrow")
	
	return node

func return_node(node : Node):
	node.get_parent().remove_child(node)
	add_child(node)
	
	if node.has_method("_reset"):
		node.call("_reset")
		
	node.process_mode = Node.PROCESS_MODE_DISABLED
	if node is Node2D:
		node.modulate.a = 0
