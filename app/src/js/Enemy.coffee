#= require Entity

components = null

do ->
	geometry = new THREE.PlaneBufferGeometry(1, 1.5)

	generateComponents = (textureName) ->
		material: new THREE.MeshBasicMaterial(map: Entity::loadTexture("/images/#{textureName}.png"))
		geometry: geometry

	components =
		c69:
			grey: generateComponents("c69_grey")
			golden: generateComponents("c69_golden")
			red: generateComponents("c69_red")
			purple: generateComponents("c69_purple")
		minibot:
			green: generateComponents("minibot_green")
			grey: generateComponents("minibot_grey")
			blue: generateComponents("minibot_blue")
			golden: generateComponents("minibot_golden")
			red: generateComponents("minibot_red")
			purple: generateComponents("minibot_purple")
		barrier:
			sand: generateComponents("sand")
			barrier: generateComponents("barrier")
			sand_barrier: generateComponents("sand_barrier")

class Enemy extends Entity
	constructor: (renderer, components) ->
		super(renderer)
		@createMesh(components.geometry, components.material)

		@movementSpeed = MS / 1000

		@collided = false

		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 25

	update: (delta) ->
		@mesh.position.y -= @movementSpeed * delta

	reset: ->
		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 25
		@collided = false

	attack: (soundSequence) ->
		if @matchSequence(soundSequence)
			soundSequence.splice(0, soundSequence.length)
			return @score
		return 0

	matchSequence: (soundSequence) ->
		length = soundSequence.length
		if length < @sequence.length
			return false

		for sound, index in @sequence
			if soundSequence[length - @sequence.length + index] != sound
				return false

		return true

class C69 extends Enemy
	constructor: (renderer, @color) ->
		super(renderer, components.c69[@color])
		@type = "c69"

		@score = 20
		@sequence = [keyCodes[1], keyCodes[2], keyCodes[1]]

class Minibot extends Enemy
	constructor: (renderer, @color) ->
		super(renderer, components.minibot[@color])
		@type = "minibot"

		@score = 10
		@sequence = [keyCodes[1], keyCodes[3]]

class Barrier extends Enemy
	constructor: (renderer, @kind) ->
		super(renderer, components.barrier[@kind])
		@type = "barrier"

	attack: -> 0
