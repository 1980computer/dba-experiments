# Project Info
# This info is presented in a widget when you share.
# http://framerjs.com/docs/#info.info

Framer.Info =
	title: "Anchored Flow"
	author: "Benjamin den Boer"
	twitter: "benjaminnathan"
	description: "A newsfeed design made using the FlowComponent."


# Import file "scroll"
sketch = Framer.Importer.load("imported/scroll@1x")

# Background
Screen.backgroundColor = "#FFF"	
 
# Set-up
flow = new FlowComponent
	backgroundColor: "#FFF"

flow.showNext(sketch.home)

# Add anchored tabBar
flow.footer = sketch.tabBar
	
# Show overlay on click of recommendations
sketch.list.onClick ->
	flow.showOverlayBottom(sketch.sheet)
	
# Go back
sketch.sheet.onClick ->
	flow.showPrevious()