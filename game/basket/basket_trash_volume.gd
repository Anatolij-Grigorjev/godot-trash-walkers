@tool
extends Sprite2D
class_name BasketTrashVolume

@export var trash_decal_scene: PackedScene = preload("res://trash/trash_paper_decal.tscn")
@export var basket_capacity: int = 20
@export var num_trash_bits: int = 0: set = manage_trash_bits

@onready var trash_holder: Node2D = $TrashHolder
@onready var basket_bounds: Vector2 = texture.get_size() * scale
@onready var trash_target_size: Vector2 = Vector2(
	basket_bounds.x / 2, 
	basket_bounds.y / (basket_capacity / 2)
)


func manage_trash_bits(next_amount):
	var current_amount = num_trash_bits
	if current_amount > next_amount:
		pop_surplus_trash_bits(current_amount, next_amount)
	elif  current_amount < next_amount:
		add_trash_bits(current_amount, next_amount)
	num_trash_bits = next_amount


func pop_surplus_trash_bits(current_num:int, next_num: int):
	if current_num <= 0:
		return
	var remove_trashes = get_node("TrashHolder").get_children().slice(next_num, current_num)
	for trash in remove_trashes:
		trash.queue_free()


func add_trash_bits(current_num: int, next_num: int):
	for idx in range(0, next_num):
		if idx < current_num:
			continue
		add_trash_at_idx(idx)


func add_trash_at_idx(idx: int):
	# add the image and set correct size
	var trash_node: Sprite2D = trash_decal_scene.instantiate()
	get_node("TrashHolder").add_child(trash_node)
	var trash_scale = Vector2(
		trash_target_size.x / trash_node.texture.get_size().x,
		trash_target_size.y / trash_node.texture.get_size().y
	)
	trash_node.apply_scale(trash_scale)
	
	# add correct image position
	trash_node.position = Vector2(0, basket_bounds.y) + (trash_target_size * Vector2(0.5, -0.5))
	trash_node.position.y -= (trash_target_size.y * (idx / 2))
	
	# move image to the right or keep left
	var trash_side: int = idx % 2
	trash_node.position.x += (trash_target_size.x * trash_side)
	trash_node.owner = get_tree().edited_scene_root
	
