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

		@movementSpeed = 3 / 1000

		@collided = false

		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 25

	update: (delta) ->
		@mesh.position.y -= @movementSpeed * delta

	reset: ->
		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 25
		@collided = false

	attack: (soundSequence) -> 0

	type: -> null

class C69 extends Enemy
	constructor: (renderer, @color) ->
		super(renderer, components.c69[@color])
		@type = "c69"

	attack: (soundSequence) ->
		if (length = soundSequence.length) >= 3
			if soundSequence[length-3] == keyCodes[1] and soundSequence[length-2] == keyCodes[2] and soundSequence[length-1] == keyCodes[1]
				soundSequence.splice(0, length)
				return 20
		return 0

class Minibot extends Enemy
	constructor: (renderer, @color) ->
		super(renderer, components.minibot[@color])
		@type = "minibot"

	attack: (soundSequence) ->
		if (length = soundSequence.length) >= 2
			if soundSequence[length-2] == keyCodes[1] and soundSequence[length-1] == keyCodes[3]
				soundSequence.splice(0, length)
				return 10
		return 0

class Barrier extends Enemy
	constructor: (renderer, @kind) ->
		super(renderer, components.barrier[@kind])
		@type = "barrier"
