extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_chao: Marker2D = $SpawnFloor
@onready var spawn_ceu: Marker2D = $SpawnSky

@onready var player: CharacterBody2D = $Player

@onready var tempo_label: Label = $UI/TimeLabel
@onready var game_over_tela: Control = $UI/GameOverScreen
@onready var recorde_label: Label = $UI/GameOverScreen/RecordLabel
@onready var btn_reiniciar: Button = $UI/GameOverScreen/ResetBtn
@onready var btn_sair: Button = $UI/GameOverScreen/ExitBtn

var cena_lobisomem = preload("res://werewolf.tscn")
var cena_perna = preload("res://hairy_leg.tscn")

var tempo_vivo: float = 0.0
var jogo_ativo: bool = true

func _ready() -> void:
	game_over_tela.visible = false
	
	player.jogador_morreu.connect(_on_player_jogador_morreu)

	btn_reiniciar.pressed.connect(_on_btn_reiniciar_pressed)
	btn_sair.pressed.connect(_on_btn_sair_pressed)
	
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _process(delta: float) -> void:
	if jogo_ativo:
		tempo_vivo += delta
		tempo_label.text = "Tempo: " + str(int(tempo_vivo)) + "s"

func _on_player_jogador_morreu() -> void:
	jogo_ativo = false
	spawn_timer.stop()

	recorde_label.text = "Você sobreviveu: " + str(int(tempo_vivo)) + " segundos!"
	
	game_over_tela.visible = true

func _on_btn_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()

func _on_btn_sair_pressed() -> void:
	get_tree().quit()

func _on_spawn_timer_timeout() -> void:
	var tipo_monstro = randi_range(0, 1)
	var novo_monstro: Area2D

	if tipo_monstro == 0:
		novo_monstro = cena_lobisomem.instantiate()
		add_child(novo_monstro)
		novo_monstro.global_position = spawn_chao.global_position
	else:
		novo_monstro = cena_perna.instantiate()
		add_child(novo_monstro)
		novo_monstro.global_position = spawn_ceu.global_position

	spawn_timer.wait_time = randf_range(1.8, 3.2)
	
