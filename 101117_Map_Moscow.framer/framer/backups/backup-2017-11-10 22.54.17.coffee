{DeviceOrientationManager} = require "DeviceOrientationManager"
orientationManager = new DeviceOrientationManager
Screen.backgroundColor = "28affa"
{ mapboxgl } = require "npm"


#Instructions
hideInstructions.onTap (event, layer) ->
	showInstructions.stateCycle()
	instructions.stateCycle()
	hideInstructions.stateCycle()

showInstructions.onTap (event, layer) ->
	showInstructions.stateCycle()
	instructions.stateCycle()
	hideInstructions.stateCycle()

showInstructions.states =
	stateA:
		opacity:1
	stateB:
		opacity:0

instructions.states =
	stateA:
		opacity:0
	stateB:
		opacity:1

hideInstructions.states =
	stateA:
		opacity:0
	stateB:
		opacity:1

showInstructions.opacity=0
instructions.opacity=1


#mapSetup
mapLayer = new Layer
	height: Screen.height
	width: Screen.width
	parent:nullLayer

mapLayer.html = "<div id='map'></div>"
mapLayer.ignoreEvents = false
mapElement = mapLayer.querySelector("#map")
mapElement.style.height = Screen.height + 'px'

# Set your Mapbox access token here
mapboxgl.accessToken = 'pk.eyJ1Ijoia2V5dXJqYWluMjEiLCJhIjoiY2lpamk4eWl5MDEycXVka242bTB5aXk5MCJ9.YwZqFTtsJKymb8vAENy3wA'


map = new mapboxgl.Map
	container: mapElement
	zoom: 15
	center: [37.6012908,55.7283648]
	style: 'mapbox://styles/keyurjain21/cj9n6g9zf36wv2slnar5m3vxd'

coordinates = {latitude : 55.7283648, longitude : 37.6012908}
success = (p) ->
	coordinates.latitude = p.coords.latitude
	coordinates.longitude = p.coords.longitude
	return

error = (msg) ->
#   print "error"
  locationCircle.backgroundColor="red"
  return


#List of coordinates
targetCoordinatesGL = [
	{latitude : 55.7638717, longitude : 37.592253},
	{latitude : 55.7601335, longitude : 37.6186486},
	{latitude : 55.7520233, longitude : 37.6174994},
	{latitude : 55.7407592, longitude : 37.6089478},
	{latitude : 55.7283648, longitude : 37.6012908}
]



#Get the device location + Fly to  
locationCircle.onTap (event, layer) ->
	navigator.geolocation.getCurrentPosition(success, error)
	Utils.delay 1, ->
		map.flyTo({center: [coordinates.longitude, coordinates.latitude]});
#distance
distance = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180
	lat1 = originCoordinates.latitude
	lon1 = originCoordinates.longitude
	
	lat2 = destinationCoordinates.latitude
	lon2 = destinationCoordinates.longitude
	
	R = 6371000 # metres
	
	φ1 = lat1 * degToRad
	φ2 = lat2 * degToRad
	Δφ = (lat2-lat1) * degToRad
	Δλ = (lon2-lon1) * degToRad
	a = Math.sin(Δφ/2) * Math.sin(Δφ/2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ/2) * Math.sin(Δλ/2)
	c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
	d = R * c
	return d

# heading
heading = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180

	lat1 = originCoordinates.latitude * degToRad
	lon1 = originCoordinates.longitude * degToRad
	lat2 = destinationCoordinates.latitude * degToRad
	lon2 = destinationCoordinates.longitude * degToRad

	angle = Math.atan2(Math.sin(lon2 - lon1) * Math.cos(lat2), Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
	headingAngle = angle * 180 / Math.PI
	headingAngle += 360 if headingAngle < 0
	return headingAngle

# Section 2

disk.opacity= 0
disk_0.opacity=0
disk_1.opacity=0
disk_2.opacity=0
disk_3.opacity=0
disk_4.opacity=0


errorText_N = new TextLayer
	parent:NorthButton
	color: "black"
	textAlign: "center"
	fontSize: 10
	opacity:0
	y:-20


errorText_0 = new TextLayer
	parent:button_0
	color: "black"
	textAlign: "center"
	fontSize: 10
	opacity:0
	y:-20

errorText_1 = new TextLayer
	parent:button_1
	color: "black"
	textAlign: "center"
	fontSize: 10
	opacity:0
	y:-20

errorText_2 = new TextLayer
	parent:button_2
	color: "black"
	textAlign: "center"
	fontSize: 10
	opacity:0
	y:-20

errorText_3 = new TextLayer
	parent:button_3
	color: "black"
	textAlign: "center"
	fontSize: 10
	opacity:0
	y:-20

errorText_4 = new TextLayer
	parent:button_4
	color: "black"
	textAlign: "center"
	fontSize: 10
	opacity:0
	y:-20



rotationNormalizer = Utils.rotationNormalizer()

orientationManager.onOrientationChange (data) ->
	compassHeading = data.compassHeading
	compassHeading *= -1 if data.elevation < 0
	NorthAngle = rotationNormalizer(compassHeading)

	sourceCoordinates = coordinates

	#List of coordinates
	targetCoordinates = targetCoordinatesGL
	
	angle_0 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[0])))
	angle_1 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[1])))
	angle_2 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[2])))
	angle_3 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[3])))
	angle_4 = NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[4])))
	

	r=Math.floor(data.compassHeading)
	
	if r<=180
		b = -r
	else b=360-r

	errorText_N.html=b


	disk.animate
		properties: rotation: NorthAngle
		time: 0.1
	
	disk_0.animate
		properties: rotation: angle_0
		time: 0.1

	disk_1.animate
		properties: rotation: angle_1
		time: 0.1
	
	disk_2.animate
		properties: rotation: angle_2
		time: 0.1

	disk_3.animate
		properties: rotation: angle_3
		time: 0.1

	disk_4.animate
		properties: rotation: angle_4
		time: 0.1


disk.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

disk_0.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

disk_1.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

disk_2.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

disk_3.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

disk_4.states=
	stateA:
		opacity:1
	stateB:
		opacity:0

errorText_N.states =
	stateA:
		opacity:1
	stateB:
		opacity:0

errorText_0.states =
	stateA:
		opacity:0
	stateB:
		opacity:0

errorText_1.states =
	stateA:
		opacity:0
	stateB:
		opacity:0

errorText_2.states =
	stateA:
		opacity:0
	stateB:
		opacity:0

errorText_3.states =
	stateA:
		opacity:0
	stateB:
		opacity:0

errorText_4.states =
	stateA:
		opacity:0
	stateB:
		opacity:0


NorthButton.onClick (event, layer) ->
	disk.stateCycle()
	errorText_N.stateCycle()
	

button_0.onClick (event, layer) ->
	disk_0.stateCycle()
	errorText_0.stateCycle()

button_1.onClick (event, layer) ->
	disk_1.stateCycle()
	errorText_1.stateCycle()


button_2.onClick (event, layer) ->
	disk_2.stateCycle()
	errorText_2.stateCycle()


button_3.onClick (event, layer) ->
	disk_3.stateCycle()
	errorText_3.stateCycle()


button_4.onClick (event, layer) ->
	disk_4.stateCycle()
	errorText_4.stateCycle()

