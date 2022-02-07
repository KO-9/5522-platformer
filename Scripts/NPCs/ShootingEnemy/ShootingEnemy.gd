extends KinematicBody2D

const CAN_MOVE = true
var can_shoot = true
var take_damage = false

const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_HEIGHT = -500
const MAX_SPEED = 200
const ACCELERATION = 40

onready var right_hand_position = $AnimatedSprite/RightHand
onready var left_hand_position = $AnimatedSprite/LeftHand

const FIREBALL = preload("res://Scripts/Projectiles/EnemyFireBall.tscn")

#Shooting
export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)
var target
var hit_pos
var state = "Run"
var player
const FOV = 90
var HIT_POINTS = 1
const DEATH_POINTS = 3
const DAMAGE = 1
var modulate_timer = Timer.new()
#Movement
var motion = Vector2()

const RIGHT = 1

var direction = RIGHT

func _ready():
	#$RayCast2D.add_exception($CollisionShape2D)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
	$ShooterTimer.wait_time = fire_rate
	player = Global.player
	modulate_timer.set_wait_time(0.2)
	modulate_timer.connect("timeout",self,"_unmodulate") 
	add_child(modulate_timer) #to process
	
func _physics_process(delta):
	#match state:
#		"Rest":#
	#		pass
		#"Attack":
	#		pass
	#	"Run":
	#		print("a")
	motion.y += GRAVITY
	var friction = false
	
	if is_on_wall():
		direction *= -1;
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	
	if direction == RIGHT:
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$AnimatedSprite.flip_h = false
	else:
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
	
	if is_on_floor():
		$AnimatedSprite.play("Run")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		$AnimatedSprite.play("Jump")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
			
	if CAN_MOVE:
		motion = move_and_slide(motion, UP)
	update()
	if target && can_shoot:
		aim()
		
	for i in get_slide_count():
		var collision = get_slide_collision(i).collider
		if collision.is_in_group("Player"):
			collision.takeDamage(DAMAGE)

func die():
	Global.TopRightHUD.incScore(DEATH_POINTS)
	queue_free()

func _free_damage():
	take_damage = false
	
func takeDamage(damage):
	if is_physics_processing():
		HIT_POINTS -= damage
		modulate_timer.start()
		$AnimatedSprite.modulate = Color(10,10,10,10)
		if HIT_POINTS <= 0:
			set_physics_process(false)
			set_collision_mask(2^2 + 1)
			$died.play()
			var timer2 = Timer.new()
			timer2.set_wait_time(0.5)
			timer2.connect("timeout",self,"die") 
			#timeout is what says in docs, in signals
			#self is who respond to the callback
			#_on_timer_timeout is the callback, can have any name
			add_child(timer2) #to process
			timer2.start()

func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)	
	#draw_line(Vector2(), player.position - position, laser_color)
	if hit_pos != null:
		pass
		#draw_line(Vector2(), (hit_pos.position - position), laser_color)
	
func aim():
	var facing = (player.position - position).normalized()
	#print(facing)
	if !$AnimatedSprite.flip_h:
		facing = Vector2(0,0)
	else:
		facing = Vector2(-0,-0)
	var angle = 90 - rad2deg(facing.angle())
	#print(angle)
	var player_to_enemy = player.position - position
	var cos_theta = facing.dot(player.position)
	#print(cos_theta)
	var angle_to_node = rad2deg(facing.angle_to(player.position))
	if abs(angle_to_node) < FOV:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position, player.position, [self], collision_mask)
		if result:
			#print(result.collider)
			hit_pos = result
			if result.collider == player:
				shoot_fireball()

func shoot_fireball():
	can_shoot = false
	$ShooterTimer.start()
	var fb = FIREBALL.instance()
	if $AnimatedSprite.flip_h:
		left_hand_position.add_child(fb)
	else:
		right_hand_position.add_child(fb)
	fb.launch($AnimatedSprite.flip_h, self)
	$shoot.play()
	pass

func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	print("body entered")
	
func be_bounced_upon(bouncer):
	if bouncer.has_method("bounce"):
		bouncer.bounce()
		takeDamage(1)
		$thud.play()

func _unmodulate():
	$AnimatedSprite.modulate = Color(1,1,1,1)

func _on_Visibility_body_exited(body):
	if body == target:
		target = null


func _on_ShooterTimer_timeout():
	can_shoot = true
