class GameManager
	constructor: (width, height) ->
		@width = width or window.innerWidth
		@height = height or window.innerHeight

		@renderer = new THREE.WebGLRenderer()
		@renderer.setSize(@width, @height - 4)

		@camera = new THREE.PerspectiveCamera(75, @width / @height, 0.1, 1000)
		@camera.position.y = -2.5
		@camera.position.z = 2
		@camera.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2.2)

		@paused = true

		@movementQueue = []

		@soundSequence = []

		@createScene()

	createScene: ->
		@scene = new THREE.Scene()
		@scene.fog = new THREE.Fog(0x000000, 10, 30)

		@road = new Road(@scene, @renderer)

		@player = new Player(@renderer)
		@scene.add(@player.mesh)

		@enemyManager = new EnemyManager(@renderer, @scene)

	resize: (width, height) ->
		@width = width or window.innerWidth
		@height = height or window.innerHeight

		@renderer.setSize(@width, @height - 4)

		@camera.aspect = @width / @height
		@camera.updateProjectionMatrix()

	keyDown: (event) ->
		key = event.keyCode
		#console.log key
		if key == keyCodes.space
			@paused = not @paused
		else if not @paused
			switch key
				when keyCodes.left
					if @movementQueue.length < 2 and not (@player.position == 0 and @player.moving == "left")
						@movementQueue.push("left")
				when keyCodes.right
					if @movementQueue.length < 2 and not (@player.position == 0 and @player.moving == "right")
						@movementQueue.push("right")

			if 49 <= key <= 52
				@playSound(key)

	playSound: (key) ->
		@soundSequence.push(key)

		if not @player.moving
			@enemyManager.attack(@player, @soundSequence)

	render: ->
		if @paused then return

		@enemyManager.render(@camera)
		@player.render(@camera)

		@renderer.render(@scene, @camera)

	update: (delta) ->
		if @paused then return

		@road.update(delta)

		if not @player.moving and @movementQueue.length > 0
			switch @movementQueue[0]
				when "left"
					@player.moveLeft()
				when "right"
					@player.moveRight()
			@movementQueue.splice(0, 1)

		@player.update(delta)

		@enemyManager.update(delta, @player, @camera)
