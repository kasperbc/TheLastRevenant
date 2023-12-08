extends Node
class_name PoolManager

var pools : Array[NodePool]

func _ready():
	pools.append(NodePool.new("missile", "res://objects/projectiles/missiles/missile.tscn", 3))
	pools.append(NodePool.new("homing_missile", "res://objects/projectiles/missiles/homing_missile.tscn", 3))
	
	for p in pools:
		add_child(p)

func get_pool(identifier) -> NodePool:
	for pool in pools:
		if pool.id == identifier:
			return pool
	
	return null

func borrow_from_pool(recipient, identifier) -> Node:
	return get_pool(identifier).borrow_node(recipient)

func return_to_pool(node, identifier):
	get_pool(identifier).return_node(node)
