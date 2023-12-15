extends Node
class_name PoolManager

var pools : Array[NodePool]

func _ready():
	create_pools()

func create_pools():
	pools.append(NodePool.new("missile", "res://objects/projectiles/missiles/missile.tscn", 15))
	# pools.append(NodePool.new("homing_missile", "res://objects/projectiles/missiles/homing_missile.tscn", 3))
	pools.append(NodePool.new("direction_missile", "res://objects/projectiles/missiles/direction_missile.tscn", 15))
	pools.append(NodePool.new("fat_missile", "res://objects/projectiles/missiles/fat_missile.tscn", 1))
	#pools.append(NodePool.new("gravity_bomb", "res://objects/projectiles/bombs/gravity_bomb.tscn", 20))
	
	for p in pools:
		add_child(p)

func get_pool(identifier) -> NodePool:
	for pool in pools:
		if pool.id == identifier:
			return pool
	
	return null

func borrow_from_pool(recipient, identifier) -> Node:
	var pool = get_pool(identifier)
	
	if pool:
		return get_pool(identifier).borrow_node(recipient)
	return null

func return_to_pool(node, identifier):
	var pool = get_pool(identifier)
	
	if pool:
		pool.call_deferred("return_node", node)
	else:
		node.queue_free()

func reset_pools():
	for p in pools:
		pass
		#p.queue_free()
	#
	#pools.clear()
	#
	#create_pools()
