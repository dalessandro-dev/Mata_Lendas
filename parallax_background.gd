extends ParallaxBackground

@export var velocidade: float = 200.0

func _process(delta: float) -> void:
	scroll_offset.x -= velocidade * delta
