extends Node2D

@export var total_time = 2.5 * 60
@onready var remaining_time = total_time
@onready var progress_bar: TextureProgressBar = get_node("TimerHud/TextureProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	remaining_time -= delta
	progress_bar.value = (remaining_time / total_time) * 100
	if remaining_time <= 0:
		get_tree().quit()
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
