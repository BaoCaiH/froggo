extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var direction = Vector2(1, 1)
var is_dead = false
var is_play_death = false

@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")
@onready var box = get_node("CollisionShape2D")
@onready var hurt_box = get_node("HurtBox")

func _ready():
	print("Frog entered")
	print(box.position)

func _physics_process(delta):
	if is_dead:
		anim.play("Death")
		# await anim.animation_finished
		# self.queue_free()
	else:
		velocity.y += gravity * delta
		if is_on_floor():
			self.velocity = Vector2(0, 0)
			if chase:
				direction = (player.position - self.position).normalized()
				sprite.flip_h = direction.x >= 0
				self.velocity = Vector2(SPEED * direction.x, JUMP_VELOCITY)
		if self.velocity.y < 0:
			anim.play("Jump")
			box.position = Vector2(5 * direction.x, -15)
			hurt_box.position = Vector2(5 * direction.x, -6)
		elif self.velocity.y > 0:
			anim.play("Fall")
			box.position = Vector2(4 * direction.x, -9)
			hurt_box.position = Vector2(4 * direction.x, 0)
		else:
			anim.play("Idle")
			box.position = Vector2(0, -9)
			hurt_box.position = Vector2(0, 0)
		move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		player = body


func _on_player_detection_body_exited(body):
	chase = false
	player = null
	anim.play("Idle")


func _on_hurt_box_area_entered(area):
	var parent = area.get_parent()
	if !is_dead && area.name == "Hitbox" && parent.name == "Player":
		# Bounce player up a bit
		parent.velocity.y = JUMP_VELOCITY
		# Play death
		is_dead = true
		
