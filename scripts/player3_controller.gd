# Called every frame. 'delta' is the elapsed time since the previous frame.

extends CharacterBody2D


#var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	var xpos = self.position.x
	var ypos = self.position.y
	var xprev = xpos
	var yprev = ypos
	var hspd
	var vspd
	var isJumping
	var pressRight = Input.is_physical_key_pressed(KEY_D)
	var pressLeft = Input.is_physical_key_pressed(KEY_A)
	print(xpos)
#	var xpos = self.position.x
#	var ypos = self.position.y
#	var rayUp = $RayUp.get_collision_point()
#	var rayDown = $RayDown.get_collision_point()
#	var rayLeft = $RayLeft.get_collision_point()
#	var rayRight = $RayRight.get_collision_point()
#	var yDown = floor(rayDown.y - (ypos + 16))
#	var yUp = floor(rayUp.y - (ypos - 16))
#	var xRight = floor(rayRight.x - (xpos + 8))
#	var xLeft = floor(rayLeft.x - (xpos - 8))
#	print("Top:", yUp, ", Bottom:", yDown, ", Left:", xLeft, ", Right:", xRight)
#	var ypos = 10
#	print(self.get_position_delta())
	hspd = 3
	
	if xpos > xprev:
		$AnimatedSprite2D.set_flip_h(false)
	if xpos < xprev:
		$AnimatedSprite2D.set_flip_h(true)
		
	
	# move right & left
	if pressRight:
		$AnimatedSprite2D.play("run")
		self.position.x += 3
			
	if pressLeft:
		$AnimatedSprite2D.play("run")
		self.position.x -= 3
	
	if not pressRight && not pressLeft:
		$AnimatedSprite2D.play("idle")
	
#	if not Input.is_physical_key_pressed(KEY_A) || not Input.is_physical_key_pressed(KEY_D):
#		$AnimatedSprite2D.play("idle")
#		if spd < -4:
#			spd += 5
#		if spd > 4:
#			spd -= 5
#
#	if spd < 5 && spd > -5 && not Input.is_physical_key_pressed(KEY_A) && not Input.is_physical_key_pressed(KEY_D):
#		spd = 0
#		if ypos < 20:
#			$AnimatedSprite2D.play("idle")
		
		
	# gravity
#	if not is_on_floor():
#		velocity.y += gravity * delta
	# jump
	if Input.is_action_just_pressed("jump"):
		$AnimatedSprite2D.play("jump")
		#print($AnimatedSprite2D.get_frame_progress())
		if $AnimatedSprite2D.frame >= 5:
			$AnimatedSprite2D.set_frame(5)
			$AnimatedSprite2D.pause()
		ypos -= 5
	#print(velocity.x)
	move_and_slide()
