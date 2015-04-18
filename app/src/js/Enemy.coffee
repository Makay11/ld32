class Enemy
	constructor: (renderer, textureURL) ->
		@width = 1
		@height = 1.5

		@movementSpeed = 3 / 1000

		@collided = false

		@texture = THREE.ImageUtils.loadTexture(textureURL)
		@texture.minFilter = THREE.LinearFilter
		@texture.anisotropy = renderer.getMaxAnisotropy()

		@geometry = new THREE.PlaneBufferGeometry(@width, @height)
		@material = new THREE.MeshBasicMaterial(map: @texture)
		@mesh = new THREE.Mesh(@geometry, @material)

		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 20
		@mesh.position.z = @height / 2

		@mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)

	update: (delta) ->
		@mesh.position.y -= @movementSpeed * delta

	reset: ->
		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 20
		@collided = false

class Enemy_C69 extends Enemy
	constructor: (renderer) ->
		super(renderer, "/images/c69.png")

class Enemy_Minibot extends Enemy
	constructor: (renderer) ->
		super(renderer, "/images/minibot.png")
