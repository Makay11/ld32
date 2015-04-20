#= require Entity

class Enemy extends Entity
	constructor: (renderer, textureName) ->
		super(renderer, "/images/" + textureName + ".png")

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
		super(renderer, "c69_" + @color)
		@type = "c69"

	attack: (soundSequence) ->
		if (length = soundSequence.length) >= 3
			if soundSequence[length-3] == keyCodes[1] and soundSequence[length-2] == keyCodes[2] and soundSequence[length-1] == keyCodes[1]
				soundSequence.splice(0, length)
				return 20
		return 0

class Minibot extends Enemy
	constructor: (renderer, @color) ->
		super(renderer, "minibot_" + @color)
		@type = "minibot"

	attack: (soundSequence) ->
		if (length = soundSequence.length) >= 2
			if soundSequence[length-2] == keyCodes[1] and soundSequence[length-1] == keyCodes[3]
				soundSequence.splice(0, length)
				return 10
		return 0
