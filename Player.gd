extends RigidBody3D # script gets access to all of the properties and functions of the node to which it's attached

var timer : float = 0.0

## How much vertical force to apply when moving.
@export_range(750, 3000) var thrust : float = 1000.0 # @exports places slider bar to inspector tab to edit this variable's values

## How much torque to apply when turning. Rotation is about the Z-axis.
@export var torque : float = 100.0

var is_transitioning : bool = false # used to prevent multiple crash/completion functions from running.

# For audio, we need to have access to children nodes. We wait for the _ready() funct
@onready var explosion_audio: AudioStreamPlayer3D = $ExplosionAudio # for accessing child node, waiting for _ready()
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var engine_thrust_audio: AudioStreamPlayer3D = $EngineThrustAudio
@onready var small_engine_thrust_audio: AudioStreamPlayer3D = $SmallEngineThrustAudio

# Particle effects here
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var small_booster_particles: GPUParticles3D = $SmallBoosterParticles
@onready var booster_particles_right: GPUParticles3D = $BoosterParticlesRight
@onready var booster_particles_left: GPUParticles3D = $BoosterParticlesLeft

@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void: # the physics process runs frame ticks, or updates, at a fixed rate
	 
	#  print(basis.x) prints local rotation vector, which itself has an x,y and z component. 
	#  print(basis.y.y) prints y-component of Y basis vector	
	
	# basic player movement
	if Input.is_action_pressed("boost"): # input action is spacebar or enter
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if engine_thrust_audio.playing == false: # to prevent audio from restarting every frame
				engine_thrust_audio.play()
	else: # to stop audio when we release the input mapping "boost" i.e. spacebar and 'w'
		booster_particles.emitting = false
		engine_thrust_audio.stop()
			
	if Input.is_action_pressed("small_thrust"): # input action is spacebar or enter
		apply_central_force(basis.y * delta * thrust * 0.55)
		small_booster_particles.emitting = true
		if small_engine_thrust_audio.playing == false:
			small_engine_thrust_audio.play()			
	else: # to stop audio when we release the input mapping "small_thrust" i.e. alt
		small_booster_particles.emitting = false
		small_engine_thrust_audio.stop()
			
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque) * delta) # use constructor to instantiate new Vector3 object
		booster_particles_right.emitting = true
	else:
		booster_particles_right.emitting = false
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque) * delta)
		booster_particles_left.emitting = true
	else:
		booster_particles_left.emitting = false
		
# connecting signal to method
func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups() && is_transitioning == false: # checks if string is in list of the body's groups
		complete_level(body.file_path)
	
	if "Hazard" in body.get_groups() && is_transitioning == false:
		crash_sequence()
		
func crash_sequence() -> void:
	print("KABOOM!")
	explosion_particles.emitting = true
	explosion_audio.play() # play audio attached to our audio node
	set_physics_process(false) # stops calling the _process function, to prevent calling multiple crash_sequence()
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(3.0) # passes a float (in seconds), how long we wait
	tween.tween_callback(get_tree().reload_current_scene)
	 

func complete_level(next_level_file: String) -> void:
	print("Safe landing! Level complete!")
	success_particles.emitting = true
	success_audio.play() 
	set_physics_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)) # using tween to change scene to the next level file
