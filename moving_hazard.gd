extends AnimatableBody3D

## Final destination to which our moving hazard moves
@export var destination : Vector3

## Final rotational position to which our moving hazard rotates. Note: -180 to 180 = 0 to 360 degrees.
@export var end_rotation : Vector3

## Time to complete tween translation from initial to final position.
@export var move_time : float = 1.0

## Time to complete tween rotation from initial to final rotation.
@export var rotate_time : float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# let's create our tween object
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination, move_time)
	#tween.tween_property(self, "global_rotation_degrees", global_rotation_degrees + end_rotation, rotate_time)
	tween.tween_property(self, "global_position", global_position, move_time)
	#tween.tween_property(self, "global_rotation_degrees", global_rotation_degrees, rotate_time)
	
	# we tween, using the self to point to this node, from a starting property to a final property value.

