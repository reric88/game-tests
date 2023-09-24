extends CharacterBody2D
var spd : int = 0
var jump_spd : int = 300
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var height : int = 200
var grounded = true
var isJumping = false
var dblJumping = false
var face
var audio_player
var jump1 = load("res://sounds/344501__jeremysykes__jump04.wav")
var jump2 = load("res://sounds/270318__littlerobotsoundfactory__jump_02.wav")

func _ready():
	audio_player = $AudioStreamPlayer
	
func sfx(sound):
	audio_player.stream = sound
	audio_player.play()

func isColliding():
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
#		print("Collided with: ", col.get_collider().position.x)
#		print("Collided with: ", get_wall_normal())


func _physics_process(delta):
	var pressRight = Input.is_physical_key_pressed(KEY_D)
	var pressLeft = Input.is_physical_key_pressed(KEY_A)
	var pressJump = Input.is_action_just_pressed("jump")
#	var animRun = $AnimatedSprite2D.play("run")
#	var animIdle = $AnimatedSprite2D.play("idle")
#	var animJump = $AnimatedSprite2D.play("jump")
#	var animSkid = $AnimatedSprite2D.play("skid")
#	var faceLeft = $AnimatedSprite2D.set_flip_h(true)
#	var faceRight = $AnimatedSprite2D.set_flip_h(false)
	var xpos = self.position.x
	var ypos = self.position.y
	var xprev = xpos
	var yprev = ypos
	var rayUp = $RayUp.get_collision_point()
	var rayDown = $RayDown.get_collision_point()
	var rayLeft = $RayLeft.get_collision_point()
	var rayRight = $RayRight.get_collision_point()
	var yDown = floor(rayDown.y - (ypos + 18))
	var yUp = floor(rayUp.y - (ypos - 7))
	var xRight = floor(rayRight.x - (xpos + 4))
	var xLeft = floor(rayLeft.x - (xpos - 10))
	var rayUp2 = $RayUp2.get_collision_point()
	var rayDown2 = $RayDown2.get_collision_point()
	var rayLeft2 = $RayLeft2.get_collision_point()
	var rayRight2 = $RayRight2.get_collision_point()
	var yDown2 = floor(rayDown2.y - (ypos + 18))
	var yUp2 = floor(rayUp2.y - (ypos - 7))
	var xRight2 = floor(rayRight2.x - (xpos + 4))
	var xLeft2 = floor(rayLeft2.x - (xpos - 10))
#	print("Top:", yUp, ", Bottom:", yDown, ", Left:", xLeft, ", Right:", xRight)
#	var ypos = 10

	velocity.x = spd
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
		
	if yDown == 0 && isJumping == true:
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

	if $RayRight.get_collider_rid() == %pinky.get_rid() && xRight <= 0:
		sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
		spd = -200
		velocity.y += -100
		print(xRight)
	if $RayLeft.get_collider_rid() == %pinky.get_rid() && xLeft >= 0:
		sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
		spd = 200
		velocity.y += -100
		print(xLeft)
	if $RayDown.get_collider_rid() == %pinky.get_rid() && yDown <= 1 && pressJump:
		sfx(preload("res://sounds/536256__hoggington__metal-gauntlet-punch-3.ogg"))
		velocity.y = -400
		print(yDown)
	if $RayRight.get_collider_rid() == %pinky2.get_rid() && xRight <= 0:
		sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
		spd = -200
		velocity.y += -100
		print(xRight)
	if $RayLeft.get_collider_rid() == %pinky2.get_rid() && xLeft >= 0:
		sfx(preload("res://sounds/458867__raclure__damage-sound-effect.mp3"))		
		spd = 200
		velocity.y += -100
		print(xLeft)
	if $RayDown.get_collider_rid() == %pinky2.get_rid() && yDown <= 1 && pressJump:
		sfx(preload("res://sounds/536256__hoggington__metal-gauntlet-punch-3.ogg"))
		velocity.y = -400
		print(yDown)
	

		
	move_and_slide()
