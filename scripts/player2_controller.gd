extends CharacterBody2D
var spd : int = 0
var jump_spd : int = 300
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var height : int = 200
var isJumping


func isColliding():
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
#		print("Collided with: ", col.get_collider().position.x)
#		print("Collided with: ", get_wall_normal())


func _physics_process(delta):
	var xpos = self.position.x
	var ypos = self.position.y
	var xprev = xpos
	var yprev = ypos
	var rayUp = $RayUp.get_collision_point()
	var rayDown = $RayDown.get_collision_point()
	var rayLeft = $RayLeft.get_collision_point()
	var rayRight = $RayRight.get_collision_point()
	var yDown = floor(rayDown.y - (ypos + 16))
	var yUp = floor(rayUp.y - (ypos - 16))
	var xRight = floor(rayRight.x - (xpos + 6))
	var xLeft = floor(rayLeft.x - (xpos - 8))
	print("Top:", yUp, ", Bottom:", yDown, ", Left:", xLeft, ", Right:", xRight)
#	var ypos = 10

	velocity.x = spd
	
	if spd > 0:
		$AnimatedSprite2D.set_flip_h(false)
	if spd < 0:
		$AnimatedSprite2D.set_flip_h(true)
		
	
	# move right
	if Input.is_physical_key_pressed(KEY_D) && xRight != 0:
		spd += 5
		if spd >= 200:
			spd = 200
		if ypos < 20:
			$AnimatedSprite2D.play("run")
#		isColliding()
#		if not is_on_wall():
#			self.position.x += 3
#		else:
#			self.position.x -= 0
			
	# move left
	if Input.is_physical_key_pressed(KEY_A) && xLeft != 0:
		spd -= 5
		if spd <= -200:
			spd = -200
		if ypos < 20:
			$AnimatedSprite2D.play("run")
#		if not is_on_wall():
#			self.position.x -= 3
#		else:
#			self.position.x += 0
	if xLeft == 0 || xRight == 0:
		$AnimatedSprite2D.play("idle")
	
	if not Input.is_physical_key_pressed(KEY_A) && spd < -4:
		spd += 5
		if ypos < 20:
			$AnimatedSprite2D.play("idle")
			
	if not Input.is_physical_key_pressed(KEY_D) && spd > 4:		
		spd -= 5
		if ypos < 20:
			$AnimatedSprite2D.play("idle")
			
			
	if spd < 5 && spd > -5 && not Input.is_physical_key_pressed(KEY_A) && not Input.is_physical_key_pressed(KEY_D):
		spd = 0
		if ypos < 20:
			$AnimatedSprite2D.play("idle")
		
		
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	# jump
	if Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("jump")
		#print($AnimatedSprite2D.get_frame_progress())
		if $AnimatedSprite2D.frame >= 5:
			$AnimatedSprite2D.set_frame(5)
			$AnimatedSprite2D.pause()
		if yDown > 30 && isJumping == false:
			isJumping = true
#			if spd > 100:
#				velocity.y -= spd * 1.2
#			if spd < -100:
#				velocity.y += spd * 1.2
#			if spd > -100 && spd < 100:
#				velocity.y -= jump_spd * .8
			velocity.y = 0

			velocity.y -= 250
			
		if yDown < 10:
#			if spd > 100:
#				velocity.y -= spd * 2
#			if spd < -100:
#				velocity.y += spd * 2
#			if spd > -100 && spd < 100:
#				velocity.y -= jump_spd
			velocity.y -= 300
			isJumping = false
	#print(velocity.x)
	move_and_slide()
