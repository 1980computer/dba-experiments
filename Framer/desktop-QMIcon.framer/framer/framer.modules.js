require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"Pointer":[function(require,module,exports){
exports.Pointer = (function() {
  var clientCoords, coords, offsetArgumentError, offsetCoords, screenArgumentError;

  function Pointer() {}

  Pointer.screen = function(event, layer) {
    var e, screenCoords;
    if (!((event != null) && (layer != null))) {
      screenArgumentError();
    }
    e = offsetCoords(event);
    if (e.x && e.y) {
      screenCoords = layer.screenFrame;
      e.x += screenCoords.x;
      e.y += screenCoords.y;
    } else {
      e = clientCoords(event);
    }
    return e;
  };

  Pointer.offset = function(event, layer) {
    var e, targetScreenCoords;
    if (!((event != null) && (layer != null))) {
      offsetArgumentError();
    }
    e = offsetCoords(event);
    if (!((e.x != null) && (e.y != null))) {
      e = clientCoords(event);
      targetScreenCoords = layer.screenFrame;
      e.x -= targetScreenCoords.x;
      e.y -= targetScreenCoords.y;
    }
    return e;
  };

  offsetCoords = function(ev) {
    var e;
    e = Events.touchEvent(ev);
    return coords(e.offsetX, e.offsetY);
  };

  clientCoords = function(ev) {
    var e;
    e = Events.touchEvent(ev);
    return coords(e.clientX, e.clientY);
  };

  coords = function(x, y) {
    return {
      x: x,
      y: y
    };
  };

  screenArgumentError = function() {
    error(null);
    return console.error("Pointer.screen() Error: You must pass event & layer arguments. \n\nExample: layer.on Events.TouchStart,(event,layer) -> Pointer.screen(event, layer)");
  };

  offsetArgumentError = function() {
    error(null);
    return console.error("Pointer.offset() Error: You must pass event & layer arguments. \n\nExample: layer.on Events.TouchStart,(event,layer) -> Pointer.offset(event, layer)");
  };

  return Pointer;

})();


},{}],"androidRipple":[function(require,module,exports){
var Pointer;

Pointer = require("Pointer").Pointer;

exports.Ripple = function(event, layer) {
  var color, eventCoords, pressFeedback, rippleCircle;
  eventCoords = Pointer.offset(event, layer);
  color = "black";
  pressFeedback = new Layer({
    superLayer: this,
    name: "pressFeedback",
    width: layer.width,
    height: layer.height,
    opacity: 0,
    backgroundColor: color
  });
  pressFeedback.states.pressed = {
    opacity: .06,
    animationOptions: {
      curve: "ease-out",
      time: .3
    }
  };
  pressFeedback.states.notPressed = {
    opacity: 0,
    animationOptions: {
      curve: "ease-out",
      time: .3
    }
  };
  pressFeedback.animate("pressed");
  rippleCircle = new Layer({
    superLayer: this,
    name: "rippleCircle",
    borderRadius: "50%",
    midX: eventCoords.x,
    midY: eventCoords.y,
    opacity: .08,
    backgroundColor: color,
    size: layer.width / 4
  });
  rippleCircle.states.pressed = {
    scale: layer.width / 60,
    opacity: 0,
    animationOptions: {
      curve: "ease-out",
      time: .8
    }
  };
  rippleCircle.animate("pressed");
  return layer.on(Events.TapEnd, function() {
    pressFeedback.animate("notPressed");
    return Utils.delay(1, function() {
      rippleCircle.destroy();
      return pressFeedback.destroy();
    });
  });
};


},{"Pointer":"Pointer"}]},{},[])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uL1VzZXJzL2Rlc2lnbi9EZXNrdG9wL2RiYS1leHBlcmltZW50cy9fZnJhbWVyL19leGFtcGxlcy9RTUljb24uZnJhbWVyL21vZHVsZXMvYW5kcm9pZFJpcHBsZS5jb2ZmZWUiLCIuLi8uLi8uLi8uLi8uLi9Vc2Vycy9kZXNpZ24vRGVza3RvcC9kYmEtZXhwZXJpbWVudHMvX2ZyYW1lci9fZXhhbXBsZXMvUU1JY29uLmZyYW1lci9tb2R1bGVzL1BvaW50ZXIuY29mZmVlIiwibm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyJdLCJzb3VyY2VzQ29udGVudCI6WyIjIE1vZHVsZSBjcmVhdGVkIGJ5IEFhcm9uIEphbWVzIHwgQXByaWwgMTZ0aCwgMjAxNlxuI1xuIyBQb2ludGVyIE1vZHVsZSBieSBKb3JkYW4gRG9ic29uIGlzIHJlcXVpcmVkIGZvciB0aGlzIG1vZHVsZVxuIyBJbnN0YWxsIHRoaXMgbW9kdWxlIGZpcnN0IGhlcmU6IGh0dHA6Ly9iaXQubHkvMWxnbU5wVFxuI1xuIyBBZGQgdGhlIGZvbGxvd2luZyBsaW5lIGF0IHRoZSB0b3Agb2YgeW91ciBwcm9qZWN0IHRvIGFjY2VzcyB0aGlzIG1vZHVsZTpcbiMgYW5kcm9pZCA9IHJlcXVpcmUgXCJhbmRyb2lkUmlwcGxlXCJcbiNcbiMgVG8gYWRkIHJpcHBsZSB0byBsYXllciwgdXNlIHRoaXMgbGluZSBvZiBjb2RlOlxuIyBsYXllck5hbWUub24oRXZlbnRzLkNsaWNrLCBhbmRyb2lkLnJpcHBsZSlcbiMgUmVwbGFjZSBsYXllck5hbWUgd2l0aCB0aGUgbmFtZSBvZiB5b3VyIGxheWVyXG4jXG4jIEF2YWlsYWJsZSBvcHRpb25zOlxuIyBZb3UgY2FuIHVzZSBhbnkgRXZlbnQgd2l0aCB0aGlzIG1vZHVsZVxuXG57UG9pbnRlcn0gPSByZXF1aXJlIFwiUG9pbnRlclwiXG5cbiMgY3JlYXRlIHJpcHBsZSBmdW5jdGlvblxuZXhwb3J0cy5SaXBwbGUgPSAoZXZlbnQsIGxheWVyKSAtPlxuXHRldmVudENvb3JkcyA9IFBvaW50ZXIub2Zmc2V0KGV2ZW50LCBsYXllcilcblxuXHQjIENoYW5nZSBjb2xvciBvZiByaXBwbGVcblx0Y29sb3IgPSBcImJsYWNrXCJcblxuXHQjIENyZWF0ZSBsYXllcnMgb24gQ2xpY2tcblx0cHJlc3NGZWVkYmFjayA9IG5ldyBMYXllclxuXHRcdHN1cGVyTGF5ZXI6IEBcblx0XHRuYW1lOiBcInByZXNzRmVlZGJhY2tcIlxuXHRcdHdpZHRoOiBsYXllci53aWR0aFxuXHRcdGhlaWdodDogbGF5ZXIuaGVpZ2h0XG5cdFx0b3BhY2l0eTogMFxuXHRcdGJhY2tncm91bmRDb2xvcjogY29sb3Jcblx0cHJlc3NGZWVkYmFjay5zdGF0ZXMucHJlc3NlZCA9XG5cdFx0b3BhY2l0eTogLjA2XG5cdFx0YW5pbWF0aW9uT3B0aW9uczogXG5cdFx0XHRjdXJ2ZTogXCJlYXNlLW91dFwiXG5cdFx0XHR0aW1lOiAuM1xuXHRwcmVzc0ZlZWRiYWNrLnN0YXRlcy5ub3RQcmVzc2VkID1cblx0XHRvcGFjaXR5OiAwXG5cdFx0YW5pbWF0aW9uT3B0aW9uczogXG5cdFx0XHRjdXJ2ZTogXCJlYXNlLW91dFwiXG5cdFx0XHR0aW1lOiAuM1xuXHRwcmVzc0ZlZWRiYWNrLmFuaW1hdGUoXCJwcmVzc2VkXCIpXG5cblx0cmlwcGxlQ2lyY2xlID0gbmV3IExheWVyXG5cdFx0c3VwZXJMYXllcjogQFxuXHRcdG5hbWU6IFwicmlwcGxlQ2lyY2xlXCJcblx0XHRib3JkZXJSYWRpdXM6IFwiNTAlXCJcblx0XHRtaWRYOiBldmVudENvb3Jkcy54XG5cdFx0bWlkWTogZXZlbnRDb29yZHMueVxuXHRcdG9wYWNpdHk6IC4wOFxuXHRcdGJhY2tncm91bmRDb2xvcjogY29sb3Jcblx0XHRzaXplOiBsYXllci53aWR0aCAvIDRcblx0cmlwcGxlQ2lyY2xlLnN0YXRlcy5wcmVzc2VkID1cblx0XHRzY2FsZTogbGF5ZXIud2lkdGggLyA2MFxuXHRcdG9wYWNpdHk6IDBcblx0XHRhbmltYXRpb25PcHRpb25zOiBcblx0XHRcdGN1cnZlOiBcImVhc2Utb3V0XCJcblx0XHRcdHRpbWU6IC44XG5cdHJpcHBsZUNpcmNsZS5hbmltYXRlKFwicHJlc3NlZFwiKVxuXG5cdCMgRGVzdHJveSBsYXllcnMgYWZ0ZXIgQ2xpY2tcblx0bGF5ZXIub24gRXZlbnRzLlRhcEVuZCwgLT5cblx0XHRwcmVzc0ZlZWRiYWNrLmFuaW1hdGUoXCJub3RQcmVzc2VkXCIpXG5cdFx0VXRpbHMuZGVsYXkgMSwgLT5cblx0XHRcdHJpcHBsZUNpcmNsZS5kZXN0cm95KClcblx0XHRcdHByZXNzRmVlZGJhY2suZGVzdHJveSgpXG4iLCIjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcbiMgQ3JlYXRlZCBieSBKb3JkYW4gUm9iZXJ0IERvYnNvbiBvbiAxNCBBdWd1c3QgMjAxNVxuIyBcbiMgVXNlIHRvIG5vcm1hbGl6ZSBzY3JlZW4gJiBvZmZzZXQgeCx5IHZhbHVlcyBmcm9tIGNsaWNrIG9yIHRvdWNoIGV2ZW50cy5cbiNcbiMgVG8gR2V0IFN0YXJ0ZWQuLi5cbiNcbiMgMS4gUGxhY2UgdGhpcyBmaWxlIGluIEZyYW1lciBTdHVkaW8gbW9kdWxlcyBkaXJlY3RvcnlcbiNcbiMgMi4gSW4geW91ciBwcm9qZWN0IGluY2x1ZGU6XG4jICAgICB7UG9pbnRlcn0gPSByZXF1aXJlIFwiUG9pbnRlclwiXG4jXG4jIDMuIEZvciBzY3JlZW4gY29vcmRpbmF0ZXM6IFxuIyAgICAgYnRuLm9uIEV2ZW50cy5DbGljaywgKGV2ZW50LCBsYXllcikgLT4gcHJpbnQgUG9pbnRlci5zY3JlZW4oZXZlbnQsIGxheWVyKVxuIyBcbiMgNC4gRm9yIGxheWVyIG9mZnNldCBjb29yZGluYXRlczogXG4jICAgICBidG4ub24gRXZlbnRzLkNsaWNrLCAoZXZlbnQsIGxheWVyKSAtPiBwcmludCBQb2ludGVyLm9mZnNldChldmVudCwgbGF5ZXIpXG4jXG4jIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblxuY2xhc3MgZXhwb3J0cy5Qb2ludGVyXG5cblx0IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cdCMgUHVibGljIE1ldGhvZHMgIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXG5cdEBzY3JlZW4gPSAoZXZlbnQsIGxheWVyKSAtPlxuXHRcdHNjcmVlbkFyZ3VtZW50RXJyb3IoKSB1bmxlc3MgZXZlbnQ/IGFuZCBsYXllcj9cblx0XHRlID0gb2Zmc2V0Q29vcmRzIGV2ZW50XG5cdFx0aWYgZS54IGFuZCBlLnlcblx0XHRcdCMgTW91c2UgRXZlbnRcblx0XHRcdHNjcmVlbkNvb3JkcyA9IGxheWVyLnNjcmVlbkZyYW1lXG5cdFx0XHRlLnggKz0gc2NyZWVuQ29vcmRzLnhcblx0XHRcdGUueSArPSBzY3JlZW5Db29yZHMueVxuXHRcdGVsc2Vcblx0XHRcdCMgVG91Y2ggRXZlbnRcblx0XHRcdGUgPSBjbGllbnRDb29yZHMgZXZlbnRcblx0XHRyZXR1cm4gZVxuXHRcdFx0XG5cdEBvZmZzZXQgPSAoZXZlbnQsIGxheWVyKSAtPlxuXHRcdG9mZnNldEFyZ3VtZW50RXJyb3IoKSB1bmxlc3MgZXZlbnQ/IGFuZCBsYXllcj9cblx0XHRlID0gb2Zmc2V0Q29vcmRzIGV2ZW50XG5cdFx0dW5sZXNzIGUueD8gYW5kIGUueT9cblx0XHRcdCMgVG91Y2ggRXZlbnRcblx0XHRcdGUgPSBjbGllbnRDb29yZHMgZXZlbnRcblx0XHRcdHRhcmdldFNjcmVlbkNvb3JkcyA9IGxheWVyLnNjcmVlbkZyYW1lXG5cdFx0XHRlLnggLT0gdGFyZ2V0U2NyZWVuQ29vcmRzLnhcblx0XHRcdGUueSAtPSB0YXJnZXRTY3JlZW5Db29yZHMueVxuXHRcdHJldHVybiBlXG5cdFxuXHQjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyNcblx0IyBQcml2YXRlIEhlbHBlciBNZXRob2RzICMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cdFxuXHRvZmZzZXRDb29yZHMgPSAoZXYpICAtPiBlID0gRXZlbnRzLnRvdWNoRXZlbnQgZXY7IHJldHVybiBjb29yZHMgZS5vZmZzZXRYLCBlLm9mZnNldFlcblx0Y2xpZW50Q29vcmRzID0gKGV2KSAgLT4gZSA9IEV2ZW50cy50b3VjaEV2ZW50IGV2OyByZXR1cm4gY29vcmRzIGUuY2xpZW50WCwgZS5jbGllbnRZXG5cdGNvb3JkcyAgICAgICA9ICh4LHkpIC0+IHJldHVybiB4OngsIHk6eVxuXHRcblx0IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cdCMgRXJyb3IgSGFuZGxlciBNZXRob2RzICMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXHRcblx0c2NyZWVuQXJndW1lbnRFcnJvciA9IC0+XG5cdFx0ZXJyb3IgbnVsbFxuXHRcdGNvbnNvbGUuZXJyb3IgXCJcIlwiXG5cdFx0XHRQb2ludGVyLnNjcmVlbigpIEVycm9yOiBZb3UgbXVzdCBwYXNzIGV2ZW50ICYgbGF5ZXIgYXJndW1lbnRzLiBcXG5cblx0XHRcdEV4YW1wbGU6IGxheWVyLm9uIEV2ZW50cy5Ub3VjaFN0YXJ0LChldmVudCxsYXllcikgLT4gUG9pbnRlci5zY3JlZW4oZXZlbnQsIGxheWVyKVwiXCJcIlxuXHRcdFx0XG5cdG9mZnNldEFyZ3VtZW50RXJyb3IgPSAtPlxuXHRcdGVycm9yIG51bGxcblx0XHRjb25zb2xlLmVycm9yIFwiXCJcIlxuXHRcdFx0UG9pbnRlci5vZmZzZXQoKSBFcnJvcjogWW91IG11c3QgcGFzcyBldmVudCAmIGxheWVyIGFyZ3VtZW50cy4gXFxuXG5cdFx0XHRFeGFtcGxlOiBsYXllci5vbiBFdmVudHMuVG91Y2hTdGFydCwoZXZlbnQsbGF5ZXIpIC0+IFBvaW50ZXIub2Zmc2V0KGV2ZW50LCBsYXllcilcIlwiXCIiLCIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUVBQTtBRG9CTSxPQUFPLENBQUM7QUFLYixNQUFBOzs7O0VBQUEsT0FBQyxDQUFBLE1BQUQsR0FBVSxTQUFDLEtBQUQsRUFBUSxLQUFSO0FBQ1QsUUFBQTtJQUFBLElBQUEsQ0FBQSxDQUE2QixlQUFBLElBQVcsZUFBeEMsQ0FBQTtNQUFBLG1CQUFBLENBQUEsRUFBQTs7SUFDQSxDQUFBLEdBQUksWUFBQSxDQUFhLEtBQWI7SUFDSixJQUFHLENBQUMsQ0FBQyxDQUFGLElBQVEsQ0FBQyxD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
