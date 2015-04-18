class Entity
	constructor: (renderer, textureURL) ->
		@width = 1
		@height = 1.5

		@texture = THREE.ImageUtils.loadTexture(textureURL)
		@texture.minFilter = THREE.LinearFilter
		@texture.anisotropy = renderer.getMaxAnisotropy()

		@geometry = new THREE.PlaneBufferGeometry(@width, @height)
		@material = new THREE.MeshBasicMaterial(map: @texture)
		@mesh = new THREE.Mesh(@geometry, @material)

		@mesh.position.z = @height / 2

		@mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)

	update: (delta) ->

	reset: ->
