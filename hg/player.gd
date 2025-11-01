extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $SwordHitbox

@export var speed: float = 80.0
@export var jump_velocity: float = -300.0
@export var attack_cooldown: float = 0.4

var can_attack: bool = true
var attacking: bool = false

# ⚙️ التحديث الفيزيائي (حركة اللاعب)
func _physics_process(delta: float) -> void:
	# الجاذبية
	if not is_on_floor():
		velocity += get_gravity() * delta

	# إذا اللاعب يهاجم، نوقف الحركة مؤقتًا
	if attacking:
		velocity.x = 0
		move_and_slide()
		return

	# القفز
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_velocity

	# الاتجاهات (يمين/يسار)
	var direction := Input.get_axis("ui_left", "ui_right")

	# عكس السبرايت حسب الاتجاه
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	# الحركة والأنيميشن
	if is_on_floor():
		if direction == 0:
			sprite.play("Idle")
		else:
			sprite.play("run")
	else:
		sprite.play("jump")

	# تحريك اللاعب
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


# 🖱️ التقاط إدخال الهجوم
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack:
		attack()


# ⚔️ دالة الهجوم (عشوائي بين 3 أنيميشنات)
func attack() -> void:
	attacking = true
	can_attack = false

	var random_attack: int = randi_range(1, 3)
	var attack_name: String = "attack" + str(random_attack)
	sprite.play(attack_name)

	# تشغيل الهيتبوكس مؤقتًا
	hitbox.monitoring = true
	await get_tree().create_timer(0.25).timeout
	hitbox.monitoring = false

	# انتظار الكولداون قبل السماح بهجوم جديد
	await get_tree().create_timer(attack_cooldown).timeout

	can_attack = true
	attacking = false
