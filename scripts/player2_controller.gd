extends CharacterBody2D
var spd : int = 0
var jump_spd : int = 300
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var height : int = 200
var grounded = true
var isJumping = false
var dblJumping = false


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
#	print("Top:", yUp, ", Bottom:", yDown, ", Left:", xLeft, ", Right:", xRight)
#	var ypos = 10

	velocity.x = spd
	
	if spd > 0:
		$AnimatedSprite2D.set_flip_h(false)
	if spd < 0:
		$AnimatedSprite2D.set_flip_h(true)
		
	
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
			isJumping = true
			velocity.y -= 300
			
		if isJumping == true && dblJumping == false:
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
	move_and_slide()
