extends KinematicBody2D

const UP = Vector2(0, -1)
var CAN_DIE = true
var GRAVITY
const JUMP_HEIGHT = -500*60
const MAX_SPEED = 200
const ACCELERATION = 50
var HIT_POINTS = 2
var CAN_MOVE = true

const FIREBALL = preload("res://Scripts/Projectiles/FireBall.tscn")
onready var right_hand_position = $AnimatedSprite/RightHand
onready var left_hand_position = $AnimatedSprite/LeftHand
onready var bounce_raycasts = $BounceRaycasts
onready var coyote_timer = $CoyoteTimer
var motion = Vector2()
var jumping = false

func _ready():
	#OS.window_fullscreen = OS.window_fullscreen
	if Global.checkpoint_coord != Vector2.ZERO:
		self.position = Global.checkpoint_coord
	set_physics_process(true)
	if Global.timer.is_stopped():
		Global.timer.start()
	Global.player = self
	GRAVITY = Global.GRAVITY*60
	
func shoot_fireball():
	var fb = FIREBALL.instance()
	if $AnimatedSprite.flip_h:
		left_hand_position.add_child(fb)
	else:
		right_hand_position.add_child(fb)
	fb.launch($AnimatedSprite.flip_h)
	pass

func takeDamage(damage):
	if is_physics_processing() && !$AnimatedSprite/AnimationPlayer.is_playing():
		$takedamage.play()
		HIT_POINTS -= damage
		$AnimatedSprite/AnimationPlayer.play("take_damage")
		#$AnimatedSprite.modulate = Color(10,10,10,10)
		#var timer = Timer.new()
		#timer.set_wait_time(0.2)
		#timer.connect("timeout",self,"_unmodulate") 
		#timeout is what says in docs, in signals
		#self is who respond to the callback
		#_on_timer_timeout is the callback, can have any name
		#add_child(timer) #to process
		#timer.start() #to start
		if HIT_POINTS <= 0:
			CAN_MOVE = false
			set_physics_process(false)
			var timer2 = Timer.new()
			timer2.set_wait_time(0.5)
			timer2.connect("timeout",self,"die") 
			#timeout is what says in docs, in signals
			#self is who respond to the callback
			#_on_timer_timeout is the callback, can have any name
			add_child(timer2) #to process
			timer2.start()

#func _unmodulate():
#	$AnimatedSprite.modulate = Color(1,1,1,1)

func die():
	if CAN_DIE:
		set_physics_process(false)
		CAN_DIE = false
		$AnimatedSprite/AnimationPlayer.play("take_damage")
		$died.play()

func _physics_process(delta):
	motion.y += GRAVITY * delta
	ACCELERATION * delta
	var friction = false
	
	if jumping &&  motion.y >= 0:
		jumping = false
		
	if CAN_MOVE:
		if Input.is_action_just_pressed("action_fire"):
			$shoot.play()
			shoot_fireball()
		
		if Input.is_action_just_pressed("ui_cancel"):
			Global.world_logic.stop_music()
			#get_tree().change_scene("Scripts/UI/Menu.tscn")
			
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Run")
		elif Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Run")
		else:
			friction = true
			$AnimatedSprite.play("Idle")
	
	if is_on_floor() || !coyote_timer.is_stopped():
		if Input.is_action_just_pressed("ui_select"):
			coyote_timer.stop()
			jumping = true
			motion.y = JUMP_HEIGHT*delta
			$jump.play()
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	
	else:
		$AnimatedSprite.play("Jump")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision,self)

	_check_bounce(delta)
	var snap = Vector2.DOWN * 16 if !jumping else Vector2.ZERO
	var was_on_floor =  is_on_floor()
	motion = move_and_slide_with_snap(motion, snap, UP)
	if !is_on_floor() && was_on_floor && !jumping:
		coyote_timer.start()
		
	pass

func bounce(bounce_velocity = JUMP_HEIGHT):
	if bounce_velocity == JUMP_HEIGHT:
		bounce_velocity /= 60
	motion.y = bounce_velocity

func _check_bounce(delta):
	if motion.y > 0:
		for raycast in bounce_raycasts.get_children():
			raycast.cast_to = Vector2.DOWN * motion * delta + Vector2.DOWN
			raycast.force_raycast_update()
			if raycast.is_colliding():
				motion.y = (raycast.get_collision_point()  - raycast.global_position).y / delta
				raycast.get_collider().entity.call_deferred("be_bounced_upon", self)
				break


func _on_CoyoteTimer_timeout():
	print("end_timer")
	pass # Replace with function body.

func getMotion():
	return motion

func _on_died_finished():
	Global.score = Global.previous_world_score
	#Global.resetTimer()
	get_tree().reload_current_scene()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "take_damage":
		print("over")#unset immunity to non-death triggers
