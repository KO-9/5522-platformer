extends KinematicBody2D

const CAN_MOVE = true

const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_HEIGHT = -500
const MAX_SPEED = 200
const ACCELERATION = 40
var HIT_POINTS = 1
var motion = Vector2()
const DEATH_POINTS = 2
const DAMAGE = 1
var damage_timer = Timer.new()
var modulate_timer = Timer.new()
var death_timer = Timer.new()

var take_damage = false

const RIGHT = 1

var direction = RIGHT

func _ready():
	damage_timer.set_wait_time(0.5)
	damage_timer.connect("timeout",self,"_free_damage") 
	add_child(damage_timer) #to process
	modulate_timer.set_wait_time(0.2)
	modulate_timer.connect("timeout",self,"_unmodulate") 
	add_child(modulate_timer) #to process
	death_timer.set_wait_time(0.5)
	death_timer.connect("timeout",self,"die") 
	add_child(death_timer) #to process
	pass # Replace with function body.

func _physics_process(delta):
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
		#$AnimatedSprite.play("Jump")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	
	if CAN_MOVE:
		motion = move_and_slide(motion, UP)
		
	for i in get_slide_count():
		var collision = get_slide_collision(i).collider
		if collision.is_in_group("Player"):
			collision.takeDamage(DAMAGE)

func die():
	Global.TopRightHUD.incScore(DEATH_POINTS)
	queue_free()

func be_bounced_upon(bouncer):
	if bouncer.has_method("bounce"):
		bouncer.bounce()
		takeDamage(1)
		$thud.play()
	
func _on_timer_timeout():
	var dyn_msg = Global.DYNAMIC_MESSAGE.instance()
	dyn_msg.rect_position = position
	var msg = dyn_msg.get_node("dynamicMessage")
	msg.set_text("sssssss+%d" % [DEATH_POINTS])
	Global.player.get_node("CanvasLayer").add_child(dyn_msg)
	Global.TopRightHUD.incScore(DEATH_POINTS)
	queue_free()

func _free_damage():
	take_damage = false

func takeDamage(damage):
	if is_physics_processing():
		HIT_POINTS -= damage
		$AnimatedSprite.modulate = Color(10,10,10,10)
		modulate_timer.start() #to start
		if HIT_POINTS <= 0:
			set_physics_process(false)
			set_collision_mask(2^2 + 1)
			$died.play()
			death_timer.start()

func _unmodulate():
	#take_damage = false
	$AnimatedSprite.modulate = Color(1,1,1,1)
