extends CanvasLayer


@export var start_points = 2
@export var dimming = Color(1, 1, 1, 135.0 / 255)
var children
var n_child
var mobs
var curr_n_mob
var prev_n_mob


func _ready():
	children = get_children()
	n_child = children.size()
	for i in range(n_child):
		if i >= start_points:
			children[i].modulate = dimming
	mobs = get_node("../Mobs")
	prev_n_mob = n_child - start_points
	curr_n_mob = prev_n_mob


func _process(delta):
	curr_n_mob = mobs.get_child_count()
	if curr_n_mob == 0:
		get_tree().quit()
	# if curr_n_mob != prev_n_mob:
	for i in range(children.size()):
		if i >= children.size() - curr_n_mob:
			children[i].modulate = dimming
		else:
			children[i].modulate = Color(1, 1, 1, 1)
