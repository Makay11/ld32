class GameManager
	constructor: (width, height) ->
		@width = width or window.innerWidth
		@height = height or window.innerHeight

		@paused = true

		@movementQueue = []

		@soundSequence = []

		@renderer = new THREE.WebGLRenderer()
		@renderer.setSize(@width, @height - 4)

		@camera = new THREE.PerspectiveCamera(75, @width / @height, 0.1, 1000)
		@camera.position.y = -2.5
		@camera.position.z = 2
		@camera.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2.2)

		@createScene()

	createScene: ->
		@scene = new THREE.Scene()
		@scene.fog = new THREE.Fog(0x000000, 10, 30)

		@road = new Road(@scene, @renderer)

		@player = new Player(@renderer)
		@scene.add(@player.mesh)

		@enemyManager = new EnemyManager(@renderer, @scene)
		@buildings = new Buildings(@renderer, @scene)

		@scene.add(@createSky())

		for floor in @createBuildingFloors()
			@scene.add(floor)

		@scene.add(@createMoon())

	createSky: ->
		geometry = new THREE.PlaneBufferGeometry(100, 100)
		texture = THREE.ImageUtils.loadTexture("/images/stars.png")
		texture.minFilter = THREE.LinearFilter
		texture.anisotropy = @renderer.getMaxAnisotropy()
		texture.wrapS = THREE.RepeatWrapping
		texture.wrapT = THREE.RepeatWrapping;
		texture.repeat.set(4, 4)
		material = new THREE.MeshBasicMaterial(map: texture)
		mesh = new THREE.Mesh(geometry, material)
		mesh.position.z = 7
		mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI)
		mesh

	createBuildingFloors: ->
		geometry = new THREE.PlaneBufferGeometry(60, 100)
		material = new THREE.MeshBasicMaterial(color: 0x454545)
		floors = [new THREE.Mesh(geometry, material), new THREE.Mesh(geometry, material)]
		offsets = [-1, 1]
		for floor, index in floors
			floor.position.x = offsets[index] * (3 + 1.5 + 30)
		floors

	createMoon: ->
		geometry = new THREE.PlaneBufferGeometry(1.1, 1.1)
		texture = THREE.ImageUtils.loadTexture("/images/moon.png")
		texture.minFilter = THREE.LinearFilter
		texture.anisotropy = @renderer.getMaxAnisotropy()
		material = new THREE.MeshBasicMaterial(map: texture)
		@moon = new THREE.Mesh(geometry, material)
		@moon.position.set(-2.5, 9, 6)
		@moon.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)
		THREEx.Transparency.init([@moon])
		@moon

	renderMoon: (camera) ->
		THREEx.Transparency.update([@moon], camera)

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

			if @paused
				@music.stop()
			else if @music
				@music.play()
			else if AudioFX.supported.mp3
				options =
					loop: true
					autoplay: true
					volume: 1

				if not AudioFX.supported.loop
					delete options.loop
					if @musicTimeout
						clearTimeout(@musicTimeout)
					callback = ->
						@music.play()
						@musicTimeout = setTimeout(callback, 5 * 60 * 1000 + 43 * 1000)

				@music = AudioFX("/audio/Cottonmouth_Timeshift.mp3", options, callback)
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

		@buildings.update(delta)

	render: ->
		if @paused then return

		@enemyManager.render(@camera)
		@player.render(@camera)

		@renderMoon(@camera)

		@renderer.render(@scene, @camera)
