extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var direction = 1

@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_floor():
		self.velocity = Vector2(0, 0)
		if chase:
			direction = (player.position - self.position).normalized()
			sprite.flip_h = direction.x >= 0
			self.velocity = Vector2(SPEED * direction.x, JUMP_VELOCITY)
	if self.velocity.y < 0:
		anim.play("Jump")
	elif self.velocity.y > 0:
		anim.play("Fall")
	else:
		anim.play("Idle")
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		player = body


func _on_player_detection_body_exited(body):
	chase = false
	player = null
	anim.play("Idle")
