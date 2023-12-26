extends RigidBody3D # script gets access to all of the properties and functions of the node to which it's attached

var timer : float = 0.0

## How much vertical force to apply when moving.
@export_range(750, 3000) var thrust : float = 1000.0 # @exports places slider bar to inspector tab to edit this variable's values

## How much torque to apply when turning. Rotation is about the Z-axis.
@export var torque : float = 100.0

var is_transitioning : bool = false # used to prevent multiple crash/completion functions from running.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	 
	#  print(basis.x)
	#  print(basis.y.y) prints y-component of Y basis vector	
	# basic player movement
	if Input.is_action_pressed("boost"): # input action is spacebar or enter
		apply_central_force(basis.y * delta * thrust)
	
		# multiply by delta to make framerate independent
		# multiply by 1000 to give a magnitude to our forced
		# basis.y gives us local rotation of the 3D node
		
	if Input.is_action_pressed("small_thrust"): # input action is spacebar or enter
		apply_central_force(basis.y * delta * thrust * 0.55)	
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque) * delta) # use constructor to instantiate new Vector3 object
	
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque) * delta)
		

# connecting signal to method
func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups() && is_transitioning == false: # checks if string is in list of the body's groups
		complete_level(body.file_path)
	
	if "Hazard" in body.get_groups() && is_transitioning == false:
		crash_sequence()
		
func crash_sequence() -> void:
	print("KABOOM!")
	set_process(false) # stops calling the _process function
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0) # passes a float (in seconds), how long we wait
	tween.tween_callback(get_tree().reload_current_scene)
	 

func complete_level(next_level_file: String) -> void:
	print("Safe landing! Level complete!")
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)) # using tween to change scene to the next level file
