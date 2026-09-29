extends Area2D

@export var velocidade: float = 340.0

func _physics_process(delta: float) -> void:
	position.x -= velocidade * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	print("Encostou em: ", body.name, " | Grupos: ", body.get_groups())
	if body.is_in_group("player"):
			body.morrer()
