extends Node2D

@onready var total_time = 5
@onready var remaining_time = total_time
@onready var progress_bar: TextureProgressBar = get_node("TimerHud/TextureProgressBar")
@onready var info_hud: CanvasLayer = get_node("InfoHud")
@onready var frog_hud: CanvasLayer = get_node("FrogHud")
@onready var mobs: Node2D = get_node("Mobs")
@onready var player: CharacterBody2D = get_node("Players/Player")
@onready var state = STATE.START
@onready var start_points = 2
@onready var dimming = Color(1, 1, 1, 135.0 / 255)

var children
var n_child
var curr_n_mob
var prev_n_mob

enum STATE {START, PLAY, WIN, LOSE}


# Called when the node enters the scene tree for the first time.
func _ready():
	children = frog_hud.get_children()
	n_child = children.size()
	for i in range(n_child):
		if i >= start_points:
			children[i].modulate = dimming
	prev_n_mob = n_child - start_points
	curr_n_mob = prev_n_mob


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	remaining_time -= delta
	progress_bar.value = (remaining_time / total_time) * 100
	if state == 0:
		if remaining_time <= 0:
			info_hud.visible = false
			total_time = 60
			remaining_time = total_time
			state = STATE.PLAY
			player.state = 1
		return

	if remaining_time <= 0:
		get_tree().quit()

	curr_n_mob = mobs.get_child_count()
	if curr_n_mob == 0:
		get_tree().quit()
	for i in range(children.size()):
		if i >= children.size() - curr_n_mob:
			children[i].modulate = dimming
		else:
			children[i].modulate = Color(1, 1, 1, 1)
