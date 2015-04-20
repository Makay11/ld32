#= require Entity

components = null

do ->
	geometry = new THREE.PlaneBufferGeometry(1, 1.5)

	generateComponents = (textureURL) ->
		material: new THREE.MeshBasicMaterial(map: Entity::loadTexture(textureURL))
		geometry: geometry

	components =
		c69:
			grey: generateComponents("/images/c69_grey.png")
			golden: generateComponents("/images/c69_golden.png")
			red: generateComponents("/images/c69_red.png")
			purple: generateComponents("/images/c69_purple.png")
		minibot:
			green: generateComponents("/images/minibot_green.png")
			grey: generateComponents("/images/minibot_grey.png")
			blue: generateComponents("/images/minibot_blue.png")
			golden: generateComponents("/images/minibot_golden.png")
			red: generateComponents("/images/minibot_red.png")
			purple: generateComponents("/images/minibot_purple.png")

class Enemy extends Entity
	constructor: (renderer, components) ->
		super(renderer)
		@createMesh(components.geometry, components.material)

		@movementSpeed = 3 / 1000

		@collided = false

		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 20

	update: (delta) ->
		@mesh.position.y -= @movementSpeed * delta

	reset: ->
		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 20
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
