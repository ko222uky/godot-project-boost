extends Node3D # script gets access to all of the properties and functions of the node to which it's attached
# e.g., it now has access to x, y and z coordinates

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello, Godot!")
	print("Don't panic!")
	print(42)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
