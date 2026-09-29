extends CharacterBody2D


const JUMP_VELOCITY = -650.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_foot: CollisionShape2D = $CollisionFoot
@onready var col_lower: CollisionShape2D = $CollisionLower

const ESCALA_NORMAL = Vector2(1.0, 1.0)
const ESCALA_ABAIXADO = Vector2(0.6, 0.6)

var pos_original_sprite: Vector2 = Vector2.ZERO

@export var offset_y_abaixado: float = 35.0

var esta_abaixado: bool = false

func _ready() -> void:
	add_to_group("player")
	pos_original_sprite = anim.position
	col_foot.disabled = false
	col_lower.disabled = true

signal jogador_morreu

func morrer() -> void:
	emit_signal("jogador_morreu")
	queue_free()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor() and not esta_abaixado:
		velocity.y = JUMP_VELOCITY

	if is_on_floor():
		if Input.is_action_pressed("lower") or Input.is_action_pressed("ui_down"):
			if not esta_abaixado:
				definir_abaixado(true)
		else:
			if esta_abaixado:
				definir_abaixado(false)

	atualizar_animacao()
	move_and_slide()

func definir_abaixado(estado: bool) -> void:
	esta_abaixado = estado

	if esta_abaixado:
		col_foot.set_deferred("disabled", true)
		col_lower.set_deferred("disabled", false)
		anim.scale = ESCALA_ABAIXADO
		anim.position.y = pos_original_sprite.y + offset_y_abaixado
	else:
		col_foot.set_deferred("disabled", false)
		col_lower.set_deferred("disabled", true)
		anim.scale = ESCALA_NORMAL
		anim.position = pos_original_sprite

func atualizar_animacao() -> void:
	if not is_on_floor():
		if anim.animation != "jump" and anim.sprite_frames.has_animation("jump"):
			anim.play("jump")
	elif esta_abaixado:
		if anim.animation != "lower":
			anim.play("lower")
	else:
		if anim.animation != "run":
			anim.play("run")
