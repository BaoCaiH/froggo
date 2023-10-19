extends Node2D

@onready var total_time = 5
@onready var remaining_time = total_time
@onready var progress_bar: TextureProgressBar = get_node("TimerHud/TextureProgressBar")
@onready var instruct_hud: Sprite2D = get_node("InfoHud/Instruction")
@onready var lose_hud: Sprite2D = get_node("InfoHud/Lose")
@onready var win_hud: Sprite2D = get_node("InfoHud/Win")
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
var set_done_time = false
var done_string: String
var tens
var digits
var tenth

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
	instruct_hud.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == STATE.LOSE:
		if not lose_hud.visible:
			lose_hud.visible = true
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://main.tscn")
		return
	if state == STATE.WIN:
		if not win_hud.visible:
			win_hud.visible = true
		if not set_done_time:
			done_string = "%0*.*f" % [4, 1, (total_time - remaining_time)]
			tens = load("res://Assets/numbers/" + done_string[0] + ".png")
			digits = load("res://Assets/numbers/" + done_string[1] + ".png")
			tenth = load("res://Assets/numbers/" + done_string[3] + ".png")
			win_hud.get_node("Tens").texture = tens
			win_hud.get_node("Digits").texture = digits
			win_hud.get_node("Tenth").texture = tenth
			set_done_time = true
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://main.tscn")
		return

	remaining_time -= delta
	progress_bar.value = (remaining_time / total_time) * 100
	if state == STATE.START:
		if remaining_time <= 0:
			instruct_hud.visible = false
			total_time = 60
			remaining_time = total_time
			state = STATE.PLAY
			player.state = 1
		return

	if remaining_time <= 0:
		state = STATE.LOSE
		player.state = 0

	curr_n_mob = mobs.get_child_count()
	if curr_n_mob == 0:
		state = STATE.WIN
		player.state = 0
	for i in range(children.size()):
		if i >= children.size() - curr_n_mob:
			children[i].modulate = dimming
		else:
			children[i].modulate = Color(1, 1, 1, 1)
