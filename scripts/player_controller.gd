extends CharacterBody2D
var spd : int = 0
var jump_spd : int = 300
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var height : int = 200
var grounded = true
var isJumping = false
var dblJumping = false
var isHit = false
var hitFrames = false
var jump1 = load("res://sounds/344501__jeremysykes__jump04.wav")
var jump2 = load("res://sounds/270318__littlerobotsoundfactory__jump_02.wav")
var maxhp = 2
var hp = maxhp
var pressRight
var pressLeft
var pressJump
var face
var audio_player
var yDown
var yUp
var xRight
var xLeft
var yDown2
var yUp2
var xRight2
var xLeft2
var rayUp
var rayDown
var rayLeft
var rayRight
var rayUp2
var rayDown2
var rayLeft2
var rayRight2
var xpos
var ypos
var xprev
var yprev

func _ready():
	audio_player = $AudioStreamPlayer
	
func sfx(sound):
	audio_player.stream = sound
	audio_player.play()

#func invinicible():
#	if isHit == true:
#		var i = 180
#		var timing = 0.0
#		var increase = 60.0
#		var timer = Timer.new()
#
#		while i > 0:
#			if i % 10 == 0:
#				$AnimatedSprite2D.modulate = Color("TRANSPARENT")
#			else:
#				$AnimatedSprite2D.modulate = Color(1, 1, 1)
#
#
#
#
#		for i in 180:
#			print(i)
#			if i % 10 == 0:
#				$AnimatedSprite2D.modulate = Color("TRANSPARENT")
#			else:
#				$AnimatedSprite2D.modulate = Color(1, 1, 1)
#		await get_tree().create_timer(3).timeout
#		isHit = false
#		$AnimatedSprite2D.modulate = Color(1, 1, 1)

func invincible():
	if isHit == true:
		set_collision_layer_value(2, false)
		var i = 0
		var time_accumulator = 0
		
		while i <= 10:
			if i % 2 == 0:
				$AnimatedSprite2D.modulate = Color(1, 1, 1, .3)
			else:
				$AnimatedSprite2D.modulate = Color(1, 1, 1)
			time_accumulator += get_process_delta_time() * 10
			while time_accumulator >= .5:
				i += 1
				time_accumulator -= .5
#			print(i)
#			print(time_accumulator)
			await $AnimatedSprite2D.frame_changed
		isHit = false
		$AnimatedSprite2D.modulate = Color(1, 1, 1)
		set_collision_layer_value(2, true)		


func _physics_process(delta):
	pressRight = Input.is_physical_key_pressed(KEY_D)
	pressLeft = Input.is_physical_key_pressed(KEY_A)
	pressJump = Input.is_action_just_pressed("jump")
	xpos = self.position.x
	ypos = self.position.y
	xprev = xpos
	yprev = ypos
	rayUp = $RayUp.get_collision_point()
	rayDown = $RayDown.get_collision_point()
	rayLeft = $RayLeft.get_collision_point()
	rayRight = $RayRight.get_collision_point()
	rayUp2 = $RayUp2.get_collision_point()
	rayDown2 = $RayDown2.get_collision_point()
	rayLeft2 = $RayLeft2.get_collision_point()
	rayRight2 = $RayRight2.get_collision_point()
	yDown = floor(rayDown.y - (ypos + 15))
	yUp = floor(rayUp.y - (ypos - 7))
	xRight = floor(rayRight.x - (xpos + 4))
	xLeft = floor(rayLeft.x - (xpos - 10))
	yDown2 = floor(rayDown2.y - (ypos + 15))
	yUp2 = floor(rayUp2.y - (ypos - 7))
	xRight2 = floor(rayRight2.x - (xpos + 4))
	xLeft2 = floor(rayLeft2.x - (xpos - 10))
#	print("Top:", yUp, ", Bottom:", yDown, ", Left:", xLeft, ", Right:", xRight)
#	var ypos = 10
#	print("yUp: ", yUp, " yUp2:", yUp2)
	velocity.x = spd
	if hp > 0:
		if spd > 0:
			$AnimatedSprite2D.set_flip_h(false)
			face = "right"
		if spd < 0:
			$AnimatedSprite2D.set_flip_h(true)
			face = "left"
			
		
		# move right
		if pressRight:
			if xRight != 0:
				spd += 5
				if spd >= 200:
					spd = 200
	#			if yDown < 5:
	#				$AnimatedSprite2D.play("run")
	#			else: 
	#				$AnimatedSprite2D.play("jump")
			if xRight <= 0 && spd >= 50:
				spd = 50
	#		isColliding()
	#		if not is_on_wall():
	#			self.position.x += 3
	#		else:
	#			self.position.x -= 0
				
		# move left
		if pressLeft:
			if xLeft != 0:
				spd -= 5
				if spd <= -200:
					spd = -200
	#			if yDown < 5:
	#				$AnimatedSprite2D.play("run")
	#			else: 
	#				if velocity.y < 0:
	#					$AnimatedSprite2D.play("fall")
	#				else:
						
			if xLeft >= 0 && spd <= -50:
				spd = -50
		
		if isJumping:
			$AnimatedSprite2D.play("jump")
		else:
			if pressRight && spd >= 5 && velocity.y == 0 || pressLeft && spd <= -5 && velocity.y == 0:
				$AnimatedSprite2D.play("run")
			else:
				if not isJumping && xLeft == 0 || not isJumping && xRight == 0 || not isJumping && spd == 0:
					$AnimatedSprite2D.play("idle")
				
			
		
		if not pressLeft && spd <= -5:
			spd += 5
			
			if yDown == 0:
				if pressRight:
					$AnimatedSprite2D.play("skid")
				else:
					$AnimatedSprite2D.play("stopping")
				
		if not pressRight && spd >= 5:		
			spd -= 5
			if yDown == 0:
				if pressLeft:
					$AnimatedSprite2D.play("skid")
				else:
					$AnimatedSprite2D.play("stopping")
			
			
		# gravity
	#	print("isJumping: ", isJumping, ", dblJumping: ", dblJumping, ", grounded: ", grounded, ", yDown: ", yDown)
	#	print(xRight)
		if not is_on_floor():
			velocity.y += gravity * delta
		# jump
		if pressJump:
			if isJumping == false:
				sfx(jump1)
				isJumping = true
				velocity.y -= 300
				
			if isJumping == true && dblJumping == false:
				sfx(jump2)
				dblJumping = true
				velocity.y = 0
				velocity.y -= 300
				
			$AnimatedSprite2D.play("jump")
	#		if $AnimatedSprite2D.frame >= 5:
	#			$AnimatedSprite2D.set_frame(5)
	#			$AnimatedSprite2D.pause()
			
		if yDown == 0 && isJumping == true || yDown2 == 0 && isJumping == true:
			isJumping = false
			dblJumping = false
			
			
			
	#	if isColliding():
	#		var faceVector
	#		var collisions
	#		if face == "left":
	#			faceVector = Vector2(-10, -20)
	#		else:
	#			faceVector = Vector2(10, -20)
	#		collisions = move_and_collide(faceVector)
		if get_collision_layer_value(2) == true: 
			if $RayRight.get_collider_rid() == %pinky.get_rid() && xRight <= 0:
				sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
				spd = -200
				velocity.y += -100
			if $RayLeft.get_collider_rid() == %pinky.get_rid() && xLeft >= 0:
				sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
				spd = 200
				velocity.y += -100
			if $RayDown.get_collider_rid() == %pinky.get_rid() && yDown <= 1 && pressJump:
				sfx(preload("res://sounds/536256__hoggington__metal-gauntlet-punch-3.ogg"))
				velocity.y = -400
			attacked()
	
	if hp <= 0:
		spd = 0
		velocity.y = 0
		$AnimatedSprite2D.play("death")
		if $AnimatedSprite2D.frame == 8:
			$AnimatedSprite2D.pause()
		
	move_and_slide()


func attacked():
#	Hit from the right
	if $RayRight.get_collider_rid() == %pinky2.get_rid() && xRight <= 1 || $RayRight2.get_collider_rid() == %pinky2.get_rid() && xRight2 <= 1:
		sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
		spd = -200
		velocity.y += -100
		isHit = true
		hp -= 1
		invincible()
		
#	Hit from the left
	if $RayLeft.get_collider_rid() == %pinky2.get_rid() && xLeft >= 1 || $RayLeft2.get_collider_rid() == %pinky2.get_rid() && xLeft2 >= 1:
		sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
		spd = 200
		velocity.y += -100
		isHit = true
		hp -= 1
		invincible()
		
#	Hit from the top
	if $RayUp.get_collider_rid() == %pinky2.get_rid() && yUp >= -3 || $RayUp2.get_collider_rid() == %pinky2.get_rid() && yUp2 >= -3:
		sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
		if face == "right":
			spd = -200
		else:
			spd = 200
		velocity.y += -100
		isHit = true
		hp -= 1
		invincible()



	if $RayDown.get_collider_rid() == %pinky2.get_rid() && yDown <= 1 && pressJump || $RayDown2.get_collider_rid() == %pinky2.get_rid() && yDown2 <= 1 && pressJump:
		sfx(preload("res://sounds/536256__hoggington__metal-gauntlet-punch-3.ogg"))
		velocity.y = -400
