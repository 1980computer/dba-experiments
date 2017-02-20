/* Made with Framer
by Benjamin den Boer
www.framerjs.com */
var Layers, bg, i, layerA, layerB, layers, len;

bg = new BackgroundLayer({
  backgroundColor: "#28AFFA"
});

layerA = new Layer({
  width: 80,
  height: 80,
  backgroundColor: "#fff",
  borderRadius: 4
});

layerA.center();

layerA.x += 50;

layerB = new Layer({
  width: 80,
  height: 80,
  backgroundColor: "#fff",
  borderRadius: 50
});

layerB.center();

layerB.x -= 50;

Layers = [layerA, layerB];

for (i = 0, len = Layers.length; i < len; i++) {
  layers = Layers[i];
  layers.states.add({
    one: {
      scale: 0.8
    },
    two: {
      scale: 1
    }
  });
  layers.states.animationOptions = {
    curve: "spring(400,10,0)"
  };
}

layerA.on(Events.Click, function() {
  return this.states.next("one", "two");
});

layerB.on(Events.Click, function() {
  return this.states.next("one", "two");
});
