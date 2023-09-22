extends CharacterBody2D
var spd : int = 0
var jump_spd : int = 300
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var height : int = 200
var isJumping = false


func _physics_process(delta):
#	var rayy = $RayCast2D.get_collision_point()
#	var ypos = self.position.y
#	var floorDistance = floor(rayy.y - ypos)
#	print(floorDistance)
	var floorDistance = 10
	


	# set speed of player
	# I will reference spd and SPEED. spd is referencing the variable (positive or negative) 
	# whereas SPEED will always represent the actual movement speed (always positive)
	velocity.x = spd
	
	# move right
	if Input.is_physical_key_pressed(KEY_D):
		# if key is pressed, increase right SPEED by increments of 5 per tic until 200, 
		# then stay at 200
		spd += 5
		if spd >= 200:
			spd = 200
	
	# move left
	if Input.is_physical_key_pressed(KEY_A):
		# if key is pressed, increase left SPEED by increments of 5 per tic until 200,
		# then stay at 200 (but is a negative value so it knows to move left)
		spd -= 5
		if spd <= -200:
			spd = -200
			
	if not Input.is_physical_key_pressed(KEY_A) && spd < 0:
		# if key is not pressed and spd value is less than 0 (to prevent activation 
		# while moving right), decrease SPEED by 6 per tic
		spd += 6
			
	if not Input.is_physical_key_pressed(KEY_D) && spd > 0:
		# if key is not pressed and spd value is greater than 0 (to prevent activation 
		# while moving left), decrease SPEED by 6 per tic
		spd -= 6
			
	if spd < 4 && spd > -4 && not Input.is_physical_key_pressed(KEY_A) && not Input.is_physical_key_pressed(KEY_D) || is_on_wall():
		# if speed is between 4 and -4 and no direction is pressed, spd variable = 0
		# (to prevent unwanted movement while no key is pressed.)
		# I chose 4 and -4 so the spd doesn't bounce between 6 and -6 from above
		spd = 0
			
	# gravity
	if not is_on_floor():
		# if not currently jumping
		velocity.y += gravity * delta
	# jump
	if Input.is_action_just_pressed("jump") && floorDistance < 30:
		# if jump is pressed and player is currently on the floor			
		if spd > 100:
			# if the spd is greater than 100, multiply spd by 1.7 
			# (to increase jump height by your speed), and subtract that from velocity.y
			# this is for right movement, because you need a negative number to go up
			# (negative y is up on the screen)
			velocity.y -= spd * 2
		if spd < -100:
			# if the spd is less than -100, multiply spd by 1.7 
			# and subtract it from velocity.y (to remain negative)
			velocity.y += spd * 2
		if spd > -100 && spd < 100:
			# default jump value
			velocity.y -= jump_spd
	
	# run the movement function
	move_and_slide()
