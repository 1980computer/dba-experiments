require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"colorThief":[function(require,module,exports){

/*

 * Include Module by adding the following line on top of your project
{ColorThief} = require "colorThief"


 * Get dominant color

colorThief.getColor imgSrc, (color) ->
	print color

 * Optional: Set custom sample quality
colorThief.getColor {url:imgSrc, quality:10}, (color) ->
	print color



 * Get color palette

 * By default, this will return 5 colors at default quality 10
colorThief.getPalette imgSrc, (colors) ->
	print colors

 * Optional: Set custom colorCount and sample quality
colorThief.getPalette {url:imgSrc, colorCount: 5, quality:10}, (colors) ->
	print colors
 */

/*!
 * Color Thief v2.0
 * by Lokesh Dhakar - http://www.lokeshdhakar.com
 *
 * License
 * -------
 * Creative Commons Attribution 2.5 License:
 * http://creativecommons.org/licenses/by/2.5/
 *
 * Thanks
 * ------
 * Nick Rabinowitz - For creating quantize.js.
 * John Schulz - For clean up and optimization. @JFSIII
 * Nathan Spady - For adding drag and drop support to the demo page.
 *
 */

/*
  CanvasImage Class
  Class that wraps the html image element and canvas.
  It also simplifies some of the canvas context manipulation
  with a set of helper functions.
 */
var CanvasImage, MMCQ, pv;

CanvasImage = function(image) {
  this.canvas = document.createElement('canvas');
  this.context = this.canvas.getContext('2d');
  document.body.appendChild(this.canvas);
  this.width = this.canvas.width = image.width;
  this.height = this.canvas.height = image.height;
  this.context.drawImage(image, 0, 0, this.width, this.height);
};

CanvasImage.prototype.clear = function() {
  this.context.clearRect(0, 0, this.width, this.height);
};

CanvasImage.prototype.update = function(imageData) {
  this.context.putImageData(imageData, 0, 0);
};

CanvasImage.prototype.getPixelCount = function() {
  return this.width * this.height;
};

CanvasImage.prototype.getImageData = function() {
  return this.context.getImageData(0, 0, this.width, this.height);
};

CanvasImage.prototype.removeCanvas = function() {
  this.canvas.parentNode.removeChild(this.canvas);
};

exports.ColorThief = function() {};


/*
 * getColor(sourceImage[, quality])
 * returns {r: num, g: num, b: num}
 *
 * Use the median cut algorithm provided by quantize.js to cluster similar
 * colors and return the base color from the largest cluster.
 *
 * Quality is an optional argument. It needs to be an integer. 1 is the highest quality settings.
 * 10 is the default. There is a trade-off between quality and speed. The bigger the number, the
 * faster a color will be returned but the greater the likelihood that it will not be the visually
 * most dominant color.
 *
 *
 */

exports.ColorThief.prototype.getColor = function(imgOptions, response) {
  var img, quality, url;
  switch (typeof imgOptions) {
    case "string":
      url = imgOptions;
      quality = 10;
      break;
    case "object":
      url = imgOptions.url;
      quality = imgOptions.quality;
  }
  img = new Image;
  img.onload = (function(_this) {
    return function() {
      var colRgb, dominantColor, palette;
      palette = _this.getColors(img, 5, quality);
      dominantColor = palette[0];
      return response(colRgb = new Color("rgb(" + dominantColor[0] + "," + dominantColor[1] + "," + dominantColor[2] + ")"));
    };
  })(this);
  img.crossOrigin = "anonymous";
  if (url.startsWith("http")) {
    return img.src = "https://crossorigin.me/" + url;
  } else {
    return img.src = url;
  }
};

exports.ColorThief.prototype.getPalette = function(imgOptions, response) {
  var colorCount, img, quality, url;
  switch (typeof imgOptions) {
    case "string":
      url = imgOptions;
      break;
    case "object":
      url = imgOptions.url;
  }
  quality = imgOptions.quality != null ? imgOptions.quality : imgOptions.quality = 10;
  colorCount = imgOptions.colorCount != null ? imgOptions.colorCount : imgOptions.colorCount = 5;
  img = new Image;
  img.onload = (function(_this) {
    return function() {
      var col, colArray, l, len, palette;
      palette = _this.getColors(img, colorCount, quality);
      colArray = [];
      for (l = 0, len = palette.length; l < len; l++) {
        col = palette[l];
        colArray.push(new Color("rgb(" + col[0] + "," + col[1] + "," + col[2] + ")"));
      }
      return response(colArray);
    };
  })(this);
  img.crossOrigin = "anonymous";
  if (url.startsWith("http")) {
    return img.src = "https://crossorigin.me/" + url;
  } else {
    return img.src = url;
  }
};


/*
 * getColors(sourceImage[, colorCount, quality])
 * returns array[ {r: num, g: num, b: num}, {r: num, g: num, b: num}, ...]
 *
 * Use the median cut algorithm provided by quantize.js to cluster similar colors.
 *
 * colorCount determines the size of the palette; the number of colors returned. If not set, it
 * defaults to 10.
 *
 * BUGGY: Function does not always return the requested amount of colors. It can be +/- 2.
 *
 * quality is an optional argument. It needs to be an integer. 1 is the highest quality settings.
 * 10 is the default. There is a trade-off between quality and speed. The bigger the number, the
 * faster the palette generation but the greater the likelihood that colors will be missed.
 *
 *
 */

exports.ColorThief.prototype.getColors = function(sourceImage, colorCount, quality) {
  var a, b, cmap, g, i, image, imageData, offset, palette, pixelArray, pixelCount, pixels, r;
  if (typeof colorCount == 'undefined') {
    colorCount = 10;
  }
  if (typeof quality == 'undefined' || quality < 1) {
    quality = 10;
  }
  image = new CanvasImage(sourceImage);
  imageData = image.getImageData();
  pixels = imageData.data;
  pixelCount = image.getPixelCount();
  pixelArray = [];
  i = 0;
  offset = void 0;
  r = void 0;
  g = void 0;
  b = void 0;
  a = void 0;
  while (i < pixelCount) {
    offset = i * 4;
    r = pixels[offset + 0];
    g = pixels[offset + 1];
    b = pixels[offset + 2];
    a = pixels[offset + 3];
    if (a >= 125) {
      if (!(r > 250 && g > 250 && b > 250)) {
        pixelArray.push([r, g, b]);
      }
    }
    i = i + quality;
  }
  cmap = MMCQ.quantize(pixelArray, colorCount);
  palette = cmap ? cmap.palette() : null;
  image.removeCanvas();
  return palette;
};


/*!
 * quantize.js Copyright 2008 Nick Rabinowitz.
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 */


/*!
 * Block below copied from Protovis: http://mbostock.github.com/protovis/
 * Copyright 2010 Stanford Visualization Group
 * Licensed under the BSD License: http://www.opensource.org/licenses/bsd-license.php
 */

if (!pv) {
  pv = {
    map: function(array, f) {
      var o;
      o = {};
      if (f) {
        return array.map((function(d, i) {
          o.index = i;
          return f.call(o, d);
        }));
      } else {
        return array.slice();
      }
    },
    naturalOrder: function(a, b) {
      if (a < b) {
        return -1;
      } else if (a > b) {
        return 1;
      } else {
        return 0;
      }
    },
    sum: function(array, f) {
      var o;
      o = {};
      return array.reduce(f ? (function(p, d, i) {
        o.index = i;
        return p + f.call(o, d);
      }) : (function(p, d) {
        return p + d;
      }));
    },
    max: function(array, f) {
      return Math.max.apply(null, f ? pv.map(array, f) : array);
    }
  };
}


/**
 * Basic Javascript port of the MMCQ (modified median cut quantization)
 * algorithm from the Leptonica library (http://www.leptonica.com/).
 * Returns a color map you can use to map original pixels to the reduced
 * palette. Still a work in progress.
 *
 * @author Nick Rabinowitz
 * @example

// array of pixels as [R,G,B] arrays
var myPixels = [[190,197,190], [202,204,200], [207,214,210], [211,214,211], [205,207,207]
                // etc
                ];
var maxColors = 4;

var cmap = MMCQ.quantize(myPixels, maxColors);
var newPalette = cmap.palette();
var newPixels = myPixels.map(function(p) {
    return cmap.map(p);
});
 */

MMCQ = (function() {
  var CMap, PQueue, VBox, fractByPopulations, getColorIndex, getHisto, maxIterations, medianCutApply, quantize, rshift, sigbits, vboxFromPixels;
  sigbits = 5;
  rshift = 8 - sigbits;
  maxIterations = 1000;
  fractByPopulations = 0.75;
  getColorIndex = function(r, g, b) {
    return (r << 2 * sigbits) + (g << sigbits) + b;
  };
  PQueue = function(comparator) {
    var contents, sort, sorted;
    contents = [];
    sorted = false;
    sort = function() {
      contents.sort(comparator);
      sorted = true;
    };
    return {
      push: function(o) {
        contents.push(o);
        sorted = false;
      },
      peek: function(index) {
        if (!sorted) {
          sort();
        }
        if (index == undefined) {
          index = contents.length - 1;
        }
        return contents[index];
      },
      pop: function() {
        if (!sorted) {
          sort();
        }
        return contents.pop();
      },
      size: function() {
        return contents.length;
      },
      map: function(f) {
        return contents.map(f);
      },
      debug: function() {
        if (!sorted) {
          sort();
        }
        return contents;
      }
    };
  };
  VBox = function(r1, r2, g1, g2, b1, b2, histo) {
    var vbox;
    vbox = this;
    vbox.r1 = r1;
    vbox.r2 = r2;
    vbox.g1 = g1;
    vbox.g2 = g2;
    vbox.b1 = b1;
    vbox.b2 = b2;
    vbox.histo = histo;
  };
  CMap = function() {
    this.vboxes = new PQueue(function(a, b) {
      return pv.naturalOrder(a.vbox.count() * a.vbox.volume(), b.vbox.count() * b.vbox.volume());
    });
  };
  getHisto = function(pixels) {
    var bval, gval, histo, histosize, index, rval;
    histosize = 1 << 3 * sigbits;
    histo = new Array(histosize);
    index = void 0;
    rval = void 0;
    gval = void 0;
    bval = void 0;
    pixels.forEach(function(pixel) {
      rval = pixel[0] >> rshift;
      gval = pixel[1] >> rshift;
      bval = pixel[2] >> rshift;
      index = getColorIndex(rval, gval, bval);
      histo[index] = (histo[index] || 0) + 1;
    });
    return histo;
  };
  vboxFromPixels = function(pixels, histo) {
    var bmax, bmin, bval, gmax, gmin, gval, rmax, rmin, rval;
    rmin = 1000000;
    rmax = 0;
    gmin = 1000000;
    gmax = 0;
    bmin = 1000000;
    bmax = 0;
    rval = void 0;
    gval = void 0;
    bval = void 0;
    pixels.forEach(function(pixel) {
      rval = pixel[0] >> rshift;
      gval = pixel[1] >> rshift;
      bval = pixel[2] >> rshift;
      if (rval < rmin) {
        rmin = rval;
      } else if (rval > rmax) {
        rmax = rval;
      }
      if (gval < gmin) {
        gmin = gval;
      } else if (gval > gmax) {
        gmax = gval;
      }
      if (bval < bmin) {
        bmin = bval;
      } else if (bval > bmax) {
        bmax = bval;
      }
    });
    return new VBox(rmin, rmax, gmin, gmax, bmin, bmax, histo);
  };
  medianCutApply = function(histo, vbox) {
    var bw, doCut, gw, i, index, j, k, lookaheadsum, maxw, partialsum, rw, sum, total;
    doCut = function(color) {
      var count2, d2, dim1, dim2, left, right, vbox1, vbox2;
      dim1 = color + '1';
      dim2 = color + '2';
      left = void 0;
      right = void 0;
      vbox1 = void 0;
      vbox2 = void 0;
      d2 = void 0;
      count2 = 0;
      i = vbox[dim1];
      while (i <= vbox[dim2]) {
        if (partialsum[i] > total / 2) {
          vbox1 = vbox.copy();
          vbox2 = vbox.copy();
          left = i - vbox[dim1];
          right = vbox[dim2] - i;
          if (left <= right) {
            d2 = Math.min(vbox[dim2] - 1, ~~(i + right / 2));
          } else {
            d2 = Math.max(vbox[dim1], ~~(i - 1 - (left / 2)));
          }
          while (!partialsum[d2]) {
            d2++;
          }
          count2 = lookaheadsum[d2];
          while (!count2 && partialsum[d2 - 1]) {
            count2 = lookaheadsum[--d2];
          }
          vbox1[dim2] = d2;
          vbox2[dim1] = vbox1[dim2] + 1;
          return [vbox1, vbox2];
        }
        i++;
      }
    };
    if (!vbox.count()) {
      return;
    }
    rw = vbox.r2 - vbox.r1 + 1;
    gw = vbox.g2 - vbox.g1 + 1;
    bw = vbox.b2 - vbox.b1 + 1;
    maxw = pv.max([rw, gw, bw]);
    if (vbox.count() == 1) {
      return [vbox.copy()];
    }

    /* Find the partial sum arrays along the selected axis. */
    total = 0;
    partialsum = [];
    lookaheadsum = [];
    i = void 0;
    j = void 0;
    k = void 0;
    sum = void 0;
    index = void 0;
    if (maxw == rw) {
      i = vbox.r1;
      while (i <= vbox.r2) {
        sum = 0;
        j = vbox.g1;
        while (j <= vbox.g2) {
          k = vbox.b1;
          while (k <= vbox.b2) {
            index = getColorIndex(i, j, k);
            sum += histo[index] || 0;
            k++;
          }
          j++;
        }
        total += sum;
        partialsum[i] = total;
        i++;
      }
    } else if (maxw == gw) {
      i = vbox.g1;
      while (i <= vbox.g2) {
        sum = 0;
        j = vbox.r1;
        while (j <= vbox.r2) {
          k = vbox.b1;
          while (k <= vbox.b2) {
            index = getColorIndex(j, i, k);
            sum += histo[index] || 0;
            k++;
          }
          j++;
        }
        total += sum;
        partialsum[i] = total;
        i++;
      }
    } else {

      /* maxw == bw */
      i = vbox.b1;
      while (i <= vbox.b2) {
        sum = 0;
        j = vbox.r1;
        while (j <= vbox.r2) {
          k = vbox.g1;
          while (k <= vbox.g2) {
            index = getColorIndex(j, k, i);
            sum += histo[index] || 0;
            k++;
          }
          j++;
        }
        total += sum;
        partialsum[i] = total;
        i++;
      }
    }
    partialsum.forEach(function(d, i) {
      lookaheadsum[i] = total - d;
    });
    if (maxw == rw) {
      return doCut('r');
    } else if (maxw == gw) {
      return doCut('g');
    } else {
      return doCut('b');
    }
  };
  quantize = function(pixels, maxcolors) {
    var cmap, histo, histosize, iter, k, nColors, pq, pq2, vbox;
    k = 0;
    iter = function(lh, target) {
      var ncolors, niters, vbox, vbox1, vbox2, vboxes;
      ncolors = lh.size();
      niters = 0;
      vbox = void 0;
      while (niters < maxIterations) {
        if (ncolors >= target) {
          return;
        }
        if (niters++ > maxIterations) {
          return;
        }
        vbox = lh.pop();
        if (!vbox.count()) {

          /* just put it back */
          lh.push(vbox);
          niters++;
          k++;
          continue;
        }
        vboxes = medianCutApply(histo, vbox);
        vbox1 = vboxes[0];
        vbox2 = vboxes[1];
        if (!vbox1) {
          return;
        }
        lh.push(vbox1);
        if (vbox2) {

          /* vbox2 can be null */
          lh.push(vbox2);
          ncolors++;
        }
      }
    };
    if (!pixels.length || maxcolors < 2 || maxcolors > 256) {
      return false;
    }
    histo = getHisto(pixels);
    histosize = 1 << 3 * sigbits;
    nColors = 0;
    histo.forEach(function() {
      nColors++;
    });
    if (nColors <= maxcolors) {

    } else {

    }
    vbox = vboxFromPixels(pixels, histo);
    pq = new PQueue(function(a, b) {
      return pv.naturalOrder(a.count(), b.count());
    });
    pq.push(vbox);
    iter(pq, fractByPopulations * maxcolors);
    pq2 = new PQueue(function(a, b) {
      return pv.naturalOrder(a.count() * a.volume(), b.count() * b.volume());
    });
    while (pq.size()) {
      pq2.push(pq.pop());
    }
    iter(pq2, maxcolors);
    cmap = new CMap;
    while (pq2.size()) {
      cmap.push(pq2.pop());
    }
    return cmap;
  };
  VBox.prototype = {
    volume: function(force) {
      var vbox;
      vbox = this;
      if (!vbox._volume || force) {
        vbox._volume = (vbox.r2 - vbox.r1 + 1) * (vbox.g2 - vbox.g1 + 1) * (vbox.b2 - vbox.b1 + 1);
      }
      return vbox._volume;
    },
    count: function(force) {
      var histo, i, j, k, npix, vbox;
      vbox = this;
      histo = vbox.histo;
      if (!vbox._count_set || force) {
        npix = 0;
        i = void 0;
        j = void 0;
        k = void 0;
        i = vbox.r1;
        while (i <= vbox.r2) {
          j = vbox.g1;
          while (j <= vbox.g2) {
            k = vbox.b1;
            while (k <= vbox.b2) {
              index = getColorIndex(i, j, k);
              npix += histo[index] || 0;
              k++;
            }
            j++;
          }
          i++;
        }
        vbox._count = npix;
        vbox._count_set = true;
      }
      return vbox._count;
    },
    copy: function() {
      var vbox;
      vbox = this;
      return new VBox(vbox.r1, vbox.r2, vbox.g1, vbox.g2, vbox.b1, vbox.b2, vbox.histo);
    },
    avg: function(force) {
      var bsum, gsum, histo, histoindex, hval, i, j, k, mult, ntot, rsum, vbox;
      vbox = this;
      histo = vbox.histo;
      if (!vbox._avg || force) {
        ntot = 0;
        mult = 1 << 8 - sigbits;
        rsum = 0;
        gsum = 0;
        bsum = 0;
        hval = void 0;
        i = void 0;
        j = void 0;
        k = void 0;
        histoindex = void 0;
        i = vbox.r1;
        while (i <= vbox.r2) {
          j = vbox.g1;
          while (j <= vbox.g2) {
            k = vbox.b1;
            while (k <= vbox.b2) {
              histoindex = getColorIndex(i, j, k);
              hval = histo[histoindex] || 0;
              ntot += hval;
              rsum += hval * (i + 0.5) * mult;
              gsum += hval * (j + 0.5) * mult;
              bsum += hval * (k + 0.5) * mult;
              k++;
            }
            j++;
          }
          i++;
        }
        if (ntot) {
          vbox._avg = [~~(rsum / ntot), ~~(gsum / ntot), ~~(bsum / ntot)];
        } else {
          vbox._avg = [~~(mult * (vbox.r1 + vbox.r2 + 1) / 2), ~~(mult * (vbox.g1 + vbox.g2 + 1) / 2), ~~(mult * (vbox.b1 + vbox.b2 + 1) / 2)];
        }
      }
      return vbox._avg;
    },
    contains: function(pixel) {
      var rval, vbox;
      vbox = this;
      rval = pixel[0] >> rshift;
      gval = pixel[1] >> rshift;
      bval = pixel[2] >> rshift;
      return rval >= vbox.r1 && rval <= vbox.r2 && gval >= vbox.g1 && gval <= vbox.g2 && bval >= vbox.b1 && bval <= vbox.b2;
    }
  };
  CMap.prototype = {
    push: function(vbox) {
      this.vboxes.push({
        vbox: vbox,
        color: vbox.avg()
      });
    },
    palette: function() {
      return this.vboxes.map(function(vb) {
        return vb.color;
      });
    },
    size: function() {
      return this.vboxes.size();
    },
    map: function(color) {
      var i, vboxes;
      vboxes = this.vboxes;
      i = 0;
      while (i < vboxes.size()) {
        if (vboxes.peek(i).vbox.contains(color)) {
          return vboxes.peek(i).color;
        }
        i++;
      }
      return this.nearest(color);
    },
    nearest: function(color) {
      var d1, d2, i, pColor, vboxes;
      vboxes = this.vboxes;
      d1 = void 0;
      d2 = void 0;
      pColor = void 0;
      i = 0;
      while (i < vboxes.size()) {
        d2 = Math.sqrt(Math.pow(color[0] - (vboxes.peek(i).color[0]), 2) + Math.pow(color[1] - (vboxes.peek(i).color[1]), 2) + Math.pow(color[2] - (vboxes.peek(i).color[2]), 2));
        if (d2 < d1 || d1 == undefined) {
          d1 = d2;
          pColor = vboxes.peek(i).color;
        }
        i++;
      }
      return pColor;
    },
    forcebw: function() {
      var highest, idx, lowest, vboxes;
      vboxes = this.vboxes;
      vboxes.sort(function(a, b) {
        return pv.naturalOrder(pv.sum(a.color), pv.sum(b.color));
      });
      lowest = vboxes[0].color;
      if (lowest[0] < 5 && lowest[1] < 5 && lowest[2] < 5) {
        vboxes[0].color = [0, 0, 0];
      }
      idx = vboxes.length - 1;
      highest = vboxes[idx].color;
      if (highest[0] > 251 && highest[1] > 251 && highest[2] > 251) {
        vboxes[idx].color = [255, 255, 255];
      }
    }
  };
  return {
    quantize: quantize
  };
})();


},{}],"myModule":[function(require,module,exports){
exports.myVar = "myVariable";

exports.myFunction = function() {
  return print("myFunction is running");
};

exports.myArray = [1, 2, 3];


},{}]},{},[])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uL1VzZXJzL2RhdmlkLmFudGhvbnlAY3Jvd25wZWFrLmNvbS9EZXNrdG9wL2RiYS1leHBlcmltZW50cy9fZnJhbWVyL19leGFtcGxlcy9pT1MtU3dpcGUuZnJhbWVyL21vZHVsZXMvbXlNb2R1bGUuY29mZmVlIiwiLi4vLi4vLi4vLi4vLi4vVXNlcnMvZGF2aWQuYW50aG9ueUBjcm93bnBlYWsuY29tL0Rlc2t0b3AvZGJhLWV4cGVyaW1lbnRzL19mcmFtZXIvX2V4YW1wbGVzL2lPUy1Td2lwZS5mcmFtZXIvbW9kdWxlcy9jb2xvclRoaWVmLmNvZmZlZSIsIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiXSwic291cmNlc0NvbnRlbnQiOlsiIyBBZGQgdGhlIGZvbGxvd2luZyBsaW5lIHRvIHlvdXIgcHJvamVjdCBpbiBGcmFtZXIgU3R1ZGlvLiBcbiMgbXlNb2R1bGUgPSByZXF1aXJlIFwibXlNb2R1bGVcIlxuIyBSZWZlcmVuY2UgdGhlIGNvbnRlbnRzIGJ5IG5hbWUsIGxpa2UgbXlNb2R1bGUubXlGdW5jdGlvbigpIG9yIG15TW9kdWxlLm15VmFyXG5cbmV4cG9ydHMubXlWYXIgPSBcIm15VmFyaWFibGVcIlxuXG5leHBvcnRzLm15RnVuY3Rpb24gPSAtPlxuXHRwcmludCBcIm15RnVuY3Rpb24gaXMgcnVubmluZ1wiXG5cbmV4cG9ydHMubXlBcnJheSA9IFsxLCAyLCAzXSIsIlxuXG5cbiMgJ2NvbG9yVGhpZWYnIG1vZHVsZSB2MS4wXG4jIGJ5IE1hcmMgS3Jlbm4sIEp1bHkgMXN0LCAyMDE2IHwgbWFyYy5rcmVubkBnbWFpbC5jb20gfCBAbWFyY19rcmVublxuXG4jIC4uLiBiYXNlZCBvbiBjb2xvclRoaWVmLmpzIGJ5IGJ5IExva2VzaCBEaGFrYXIgaHR0cDovL3d3dy5sb2tlc2hkaGFrYXIuY29tXG4jIGFuZCBrdWx0dXJhdmVzaGNoaVxuXG5cbiMgVGhlICdjb2xvclRoaWVmJyBtb2R1bGUgYWxsb3dzIHlvdSB0byBleHRyYWN0IHRoZSBkb21pbmFudCBjb2xvcihzKSBvZiBpbWFnZXMuXG5cblxuIyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLVxuXG4jIFRoZSBmb2xsb3dpbmcgaXMgYSBzbGlnaHRseSBtb2RpZmllZCwgYXV0by1jb252ZXJ0ZWQgY29mZmVlc2NyaXB0IHZlcnNpb25cbiMgb2YgQ29sb3IgVGhpZWYsIGJhc2VkIG9uIGEgUFIgYnkga3VsdHVyYXZlc2hjaGkgKGh0dHBzOi8vZ2l0aHViLmNvbS9sb2tlc2gvY29sb3ItdGhpZWYvcHVsbC84NClcblxuXG5cbiMgVXNhZ2U6XG4jIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tXG4jIyNcblxuIyBJbmNsdWRlIE1vZHVsZSBieSBhZGRpbmcgdGhlIGZvbGxvd2luZyBsaW5lIG9uIHRvcCBvZiB5b3VyIHByb2plY3RcbntDb2xvclRoaWVmfSA9IHJlcXVpcmUgXCJjb2xvclRoaWVmXCJcblxuXG4jIEdldCBkb21pbmFudCBjb2xvclxuXG5jb2xvclRoaWVmLmdldENvbG9yIGltZ1NyYywgKGNvbG9yKSAtPlxuXHRwcmludCBjb2xvclxuXG4jIE9wdGlvbmFsOiBTZXQgY3VzdG9tIHNhbXBsZSBxdWFsaXR5XG5jb2xvclRoaWVmLmdldENvbG9yIHt1cmw6aW1nU3JjLCBxdWFsaXR5OjEwfSwgKGNvbG9yKSAtPlxuXHRwcmludCBjb2xvclxuXG5cblxuIyBHZXQgY29sb3IgcGFsZXR0ZVxuXG4jIEJ5IGRlZmF1bHQsIHRoaXMgd2lsbCByZXR1cm4gNSBjb2xvcnMgYXQgZGVmYXVsdCBxdWFsaXR5IDEwXG5jb2xvclRoaWVmLmdldFBhbGV0dGUgaW1nU3JjLCAoY29sb3JzKSAtPlxuXHRwcmludCBjb2xvcnNcblxuIyBPcHRpb25hbDogU2V0IGN1c3RvbSBjb2xvckNvdW50IGFuZCBzYW1wbGUgcXVhbGl0eVxuY29sb3JUaGllZi5nZXRQYWxldHRlIHt1cmw6aW1nU3JjLCBjb2xvckNvdW50OiA1LCBxdWFsaXR5OjEwfSwgKGNvbG9ycykgLT5cblx0cHJpbnQgY29sb3JzXG5cbiMjI1xuXG5cbiMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1cblxuIyMjIVxuIyBDb2xvciBUaGllZiB2Mi4wXG4jIGJ5IExva2VzaCBEaGFrYXIgLSBodHRwOi8vd3d3Lmxva2VzaGRoYWthci5jb21cbiNcbiMgTGljZW5zZVxuIyAtLS0tLS0tXG4jIENyZWF0aXZlIENvbW1vbnMgQXR0cmlidXRpb24gMi41IExpY2Vuc2U6XG4jIGh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL2xpY2Vuc2VzL2J5LzIuNS9cbiNcbiMgVGhhbmtzXG4jIC0tLS0tLVxuIyBOaWNrIFJhYmlub3dpdHogLSBGb3IgY3JlYXRpbmcgcXVhbnRpemUuanMuXG4jIEpvaG4gU2NodWx6IC0gRm9yIGNsZWFuIHVwIGFuZCBvcHRpbWl6YXRpb24uIEBKRlNJSUlcbiMgTmF0aGFuIFNwYWR5IC0gRm9yIGFkZGluZyBkcmFnIGFuZCBkcm9wIHN1cHBvcnQgdG8gdGhlIGRlbW8gcGFnZS5cbiNcbiMjI1xuXG5cbiMjI1xuICBDYW52YXNJbWFnZSBDbGFzc1xuICBDbGFzcyB0aGF0IHdyYXBzIHRoZSBodG1sIGltYWdlIGVsZW1lbnQgYW5kIGNhbnZhcy5cbiAgSXQgYWxzbyBzaW1wbGlmaWVzIHNvbWUgb2YgdGhlIGNhbnZhcyBjb250ZXh0IG1hbmlwdWxhdGlvblxuICB3aXRoIGEgc2V0IG9mIGhlbHBlciBmdW5jdGlvbnMuXG4jIyNcblxuQ2FudmFzSW1hZ2UgPSAoaW1hZ2UpIC0+XG4gIEBjYW52YXMgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdjYW52YXMnKVxuICBAY29udGV4dCA9IEBjYW52YXMuZ2V0Q29udGV4dCgnMmQnKVxuICBkb2N1bWVudC5ib2R5LmFwcGVuZENoaWxkIEBjYW52YXNcbiAgQHdpZHRoID0gQGNhbnZhcy53aWR0aCA9IGltYWdlLndpZHRoXG4gIEBoZWlnaHQgPSBAY2FudmFzLmhlaWdodCA9IGltYWdlLmhlaWdodFxuICBAY29udGV4dC5kcmF3SW1hZ2UgaW1hZ2UsIDAsIDAsIEB3aWR0aCwgQGhlaWdodFxuICByZXR1cm5cblxuQ2FudmFzSW1hZ2U6OmNsZWFyID0gLT5cbiAgQGNvbnRleHQuY2xlYXJSZWN0IDAsIDAsIEB3aWR0aCwgQGhlaWdodFxuICByZXR1cm5cblxuQ2FudmFzSW1hZ2U6OnVwZGF0ZSA9IChpbWFnZURhdGEpIC0+XG4gIEBjb250ZXh0LnB1dEltYWdlRGF0YSBpbWFnZURhdGEsIDAsIDBcbiAgcmV0dXJuXG5cbkNhbnZhc0ltYWdlOjpnZXRQaXhlbENvdW50ID0gLT5cbiAgQHdpZHRoICogQGhlaWdodFxuXG5DYW52YXNJbWFnZTo6Z2V0SW1hZ2VEYXRhID0gLT5cbiAgQGNvbnRleHQuZ2V0SW1hZ2VEYXRhIDAsIDAsIEB3aWR0aCwgQGhlaWdodFxuXG5DYW52YXNJbWFnZTo6cmVtb3ZlQ2FudmFzID0gLT5cbiAgQGNhbnZhcy5wYXJlbnROb2RlLnJlbW92ZUNoaWxkIEBjYW52YXNcbiAgcmV0dXJuXG5cbmV4cG9ydHMuQ29sb3JUaGllZiA9IC0+XG5cbiMjI1xuIyBnZXRDb2xvcihzb3VyY2VJbWFnZVssIHF1YWxpdHldKVxuIyByZXR1cm5zIHtyOiBudW0sIGc6IG51bSwgYjogbnVtfVxuI1xuIyBVc2UgdGhlIG1lZGlhbiBjdXQgYWxnb3JpdGhtIHByb3ZpZGVkIGJ5IHF1YW50aXplLmpzIHRvIGNsdXN0ZXIgc2ltaWxhclxuIyBjb2xvcnMgYW5kIHJldHVybiB0aGUgYmFzZSBjb2xvciBmcm9tIHRoZSBsYXJnZXN0IGNsdXN0ZXIuXG4jXG4jIFF1YWxpdHkgaXMgYW4gb3B0aW9uYWwgYXJndW1lbnQuIEl0IG5lZWRzIHRvIGJlIGFuIGludGVnZXIuIDEgaXMgdGhlIGhpZ2hlc3QgcXVhbGl0eSBzZXR0aW5ncy5cbiMgMTAgaXMgdGhlIGRlZmF1bHQuIFRoZXJlIGlzIGEgdHJhZGUtb2ZmIGJldHdlZW4gcXVhbGl0eSBhbmQgc3BlZWQuIFRoZSBiaWdnZXIgdGhlIG51bWJlciwgdGhlXG4jIGZhc3RlciBhIGNvbG9yIHdpbGwgYmUgcmV0dXJuZWQgYnV0IHRoZSBncmVhdGVyIHRoZSBsaWtlbGlob29kIHRoYXQgaXQgd2lsbCBub3QgYmUgdGhlIHZpc3VhbGx5XG4jIG1vc3QgZG9taW5hbnQgY29sb3IuXG4jXG4jIFxuIyMjXG5cbmV4cG9ydHMuQ29sb3JUaGllZjo6Z2V0Q29sb3IgPSAoaW1nT3B0aW9ucywgcmVzcG9uc2UpIC0+XG5cbiAgc3dpdGNoIHR5cGVvZiBpbWdPcHRpb25zXG4gICAgd2hlbiBcInN0cmluZ1wiXG4gICAgICB1cmwgPSBpbWdPcHRpb25zXG4gICAgICBxdWFsaXR5ID0gMTBcbiAgICB3aGVuIFwib2JqZWN0XCJcbiAgICAgIHVybCA9IGltZ09wdGlvbnMudXJsXG4gICAgICBxdWFsaXR5ID0gaW1nT3B0aW9ucy5xdWFsaXR5XG5cblxuICBpbWcgPSBuZXcgSW1hZ2VcblxuICBpbWcub25sb2FkID0gPT5cbiAgICBwYWxldHRlID0gQGdldENvbG9ycyhpbWcsIDUsIHF1YWxpdHkpXG4gICAgZG9taW5hbnRDb2xvciA9IHBhbGV0dGVbMF1cbiAgICByZXNwb25zZShjb2xSZ2IgPSBuZXcgQ29sb3IoXCJyZ2IoI3tkb21pbmFudENvbG9yWzBdfSwje2RvbWluYW50Q29sb3JbMV19LCN7ZG9taW5hbnRDb2xvclsyXX0pXCIpKVxuXG4gIGltZy5jcm9zc09yaWdpbiA9IFwiYW5vbnltb3VzXCJcbiAgaWYgdXJsLnN0YXJ0c1dpdGgoXCJodHRwXCIpIHRoZW4gaW1nLnNyYyA9IFwiaHR0cHM6Ly9jcm9zc29yaWdpbi5tZS8je3VybH1cIiBlbHNlIGltZy5zcmMgPSB1cmxcblxuXG5cbmV4cG9ydHMuQ29sb3JUaGllZjo6Z2V0UGFsZXR0ZSA9IChpbWdPcHRpb25zLCByZXNwb25zZSkgLT5cblxuICBzd2l0Y2ggdHlwZW9mIGltZ09wdGlvbnNcbiAgICB3aGVuIFwic3RyaW5nXCIgdGhlbiB1cmwgPSBpbWdPcHRpb25zXG4gICAgd2hlbiBcIm9iamVjdFwiIHRoZW4gdXJsID0gaW1nT3B0aW9ucy51cmxcblxuXG4gIHF1YWxpdHkgICAgPSBpbWdPcHRpb25zLnF1YWxpdHkgICAgPz0gMTBcbiAgY29sb3JDb3VudCA9IGltZ09wdGlvbnMuY29sb3JDb3VudCA/PSA1XG5cblxuICBpbWcgPSBuZXcgSW1hZ2VcblxuICBpbWcub25sb2FkID0gPT5cbiAgICBwYWxldHRlID0gQGdldENvbG9ycyhpbWcsIGNvbG9yQ291bnQsIHF1YWxpdHkpXG5cbiAgICBjb2xBcnJheSA9IFtdXG5cblxuICAgIGZvciBjb2wgaW4gcGFsZXR0ZVxuICAgICAgY29sQXJyYXkucHVzaChuZXcgQ29sb3IoXCJyZ2IoI3tjb2xbMF19LCN7Y29sWzFdfSwje2NvbFsyXX0pXCIpKVxuXG4gICAgcmVzcG9uc2UoY29sQXJyYXkpXG5cblxuICBpbWcuY3Jvc3NPcmlnaW4gPSBcImFub255bW91c1wiXG4gIGlmIHVybC5zdGFydHNXaXRoKFwiaHR0cFwiKSB0aGVuIGltZy5zcmMgPSBcImh0dHBzOi8vY3Jvc3NvcmlnaW4ubWUvI3t1cmx9XCIgZWxzZSBpbWcuc3JjID0gdXJsXG5cblxuXG5cbiMjI1xuIyBnZXRDb2xvcnMoc291cmNlSW1hZ2VbLCBjb2xvckNvdW50LCBxdWFsaXR5XSlcbiMgcmV0dXJucyBhcnJheVsge3I6IG51bSwgZzogbnVtLCBiOiBudW19LCB7cjogbnVtLCBnOiBudW0sIGI6IG51bX0sIC4uLl1cbiNcbiMgVXNlIHRoZSBtZWRpYW4gY3V0IGFsZ29yaXRobSBwcm92aWRlZCBieSBxdWFudGl6ZS5qcyB0byBjbHVzdGVyIHNpbWlsYXIgY29sb3JzLlxuI1xuIyBjb2xvckNvdW50IGRldGVybWluZXMgdGhlIHNpemUgb2YgdGhlIHBhbGV0dGU7IHRoZSBudW1iZXIgb2YgY29sb3JzIHJldHVybmVkLiBJZiBub3Qgc2V0LCBpdFxuIyBkZWZhdWx0cyB0byAxMC5cbiNcbiMgQlVHR1k6IEZ1bmN0aW9uIGRvZXMgbm90IGFsd2F5cyByZXR1cm4gdGhlIHJlcXVlc3RlZCBhbW91bnQgb2YgY29sb3JzLiBJdCBjYW4gYmUgKy8tIDIuXG4jXG4jIHF1YWxpdHkgaXMgYW4gb3B0aW9uYWwgYXJndW1lbnQuIEl0IG5lZWRzIHRvIGJlIGFuIGludGVnZXIuIDEgaXMgdGhlIGhpZ2hlc3QgcXVhbGl0eSBzZXR0aW5ncy5cbiMgMTAgaXMgdGhlIGRlZmF1bHQuIFRoZXJlIGlzIGEgdHJhZGUtb2ZmIGJldHdlZW4gcXVhbGl0eSBhbmQgc3BlZWQuIFRoZSBiaWdnZXIgdGhlIG51bWJlciwgdGhlXG4jIGZhc3RlciB0aGUgcGFsZXR0ZSBnZW5lcmF0aW9uIGJ1dCB0aGUgZ3JlYXRlciB0aGUgbGlrZWxpaG9vZCB0aGF0IGNvbG9ycyB3aWxsIGJlIG1pc3NlZC5cbiNcbiNcbiMjI1xuXG5leHBvcnRzLkNvbG9yVGhpZWY6OmdldENvbG9ycyA9IChzb3VyY2VJbWFnZSwgY29sb3JDb3VudCwgcXVhbGl0eSkgLT5cblxuICBpZiBgdHlwZW9mIGNvbG9yQ291bnQgPT0gJ3VuZGVmaW5lZCdgXG4gICAgY29sb3JDb3VudCA9IDEwXG4gIGlmIGB0eXBlb2YgcXVhbGl0eSA9PSAndW5kZWZpbmVkJ2Agb3IgcXVhbGl0eSA8IDFcbiAgICBxdWFsaXR5ID0gMTBcbiAgIyBDcmVhdGUgY3VzdG9tIENhbnZhc0ltYWdlIG9iamVjdFxuICBpbWFnZSA9IG5ldyBDYW52YXNJbWFnZShzb3VyY2VJbWFnZSlcbiAgaW1hZ2VEYXRhID0gaW1hZ2UuZ2V0SW1hZ2VEYXRhKClcbiAgcGl4ZWxzID0gaW1hZ2VEYXRhLmRhdGFcbiAgcGl4ZWxDb3VudCA9IGltYWdlLmdldFBpeGVsQ291bnQoKVxuICAjIFN0b3JlIHRoZSBSR0IgdmFsdWVzIGluIGFuIGFycmF5IGZvcm1hdCBzdWl0YWJsZSBmb3IgcXVhbnRpemUgZnVuY3Rpb25cbiAgcGl4ZWxBcnJheSA9IFtdXG4gIGkgPSAwXG4gIG9mZnNldCA9IHVuZGVmaW5lZFxuICByID0gdW5kZWZpbmVkXG4gIGcgPSB1bmRlZmluZWRcbiAgYiA9IHVuZGVmaW5lZFxuICBhID0gdW5kZWZpbmVkXG4gIHdoaWxlIGkgPCBwaXhlbENvdW50XG4gICAgb2Zmc2V0ID0gaSAqIDRcbiAgICByID0gcGl4ZWxzW29mZnNldCArIDBdXG4gICAgZyA9IHBpeGVsc1tvZmZzZXQgKyAxXVxuICAgIGIgPSBwaXhlbHNbb2Zmc2V0ICsgMl1cbiAgICBhID0gcGl4ZWxzW29mZnNldCArIDNdXG4gICAgIyBJZiBwaXhlbCBpcyBtb3N0bHkgb3BhcXVlIGFuZCBub3Qgd2hpdGVcbiAgICBpZiBhID49IDEyNVxuICAgICAgaWYgIShyID4gMjUwIGFuZCBnID4gMjUwIGFuZCBiID4gMjUwKVxuICAgICAgICBwaXhlbEFycmF5LnB1c2ggW1xuICAgICAgICAgIHJcbiAgICAgICAgICBnXG4gICAgICAgICAgYlxuICAgICAgICBdXG4gICAgaSA9IGkgKyBxdWFsaXR5XG4gICMgU2VuZCBhcnJheSB0byBxdWFudGl6ZSBmdW5jdGlvbiB3aGljaCBjbHVzdGVycyB2YWx1ZXNcbiAgIyB1c2luZyBtZWRpYW4gY3V0IGFsZ29yaXRobVxuICBjbWFwID0gTU1DUS5xdWFudGl6ZShwaXhlbEFycmF5LCBjb2xvckNvdW50KVxuICBwYWxldHRlID0gaWYgY21hcCB0aGVuIGNtYXAucGFsZXR0ZSgpIGVsc2UgbnVsbFxuICAjIENsZWFuIHVwXG4gIGltYWdlLnJlbW92ZUNhbnZhcygpXG4gIHBhbGV0dGVcblxuIyMjIVxuIyBxdWFudGl6ZS5qcyBDb3B5cmlnaHQgMjAwOCBOaWNrIFJhYmlub3dpdHouXG4jIExpY2Vuc2VkIHVuZGVyIHRoZSBNSVQgbGljZW5zZTogaHR0cDovL3d3dy5vcGVuc291cmNlLm9yZy9saWNlbnNlcy9taXQtbGljZW5zZS5waHBcbiMjI1xuXG4jIGZpbGwgb3V0IGEgY291cGxlIHByb3RvdmlzIGRlcGVuZGVuY2llc1xuXG4jIyMhXG4jIEJsb2NrIGJlbG93IGNvcGllZCBmcm9tIFByb3RvdmlzOiBodHRwOi8vbWJvc3RvY2suZ2l0aHViLmNvbS9wcm90b3Zpcy9cbiMgQ29weXJpZ2h0IDIwMTAgU3RhbmZvcmQgVmlzdWFsaXphdGlvbiBHcm91cFxuIyBMaWNlbnNlZCB1bmRlciB0aGUgQlNEIExpY2Vuc2U6IGh0dHA6Ly93d3cub3BlbnNvdXJjZS5vcmcvbGljZW5zZXMvYnNkLWxpY2Vuc2UucGhwXG4jIyNcblxuaWYgIXB2XG4gIHB2ID0gXG4gICAgbWFwOiAoYXJyYXksIGYpIC0+XG4gICAgICBvID0ge31cbiAgICAgIGlmIGYgdGhlbiBhcnJheS5tYXAoKChkLCBpKSAtPlxuICAgICAgICBvLmluZGV4ID0gaVxuICAgICAgICBmLmNhbGwgbywgZFxuICAgICAgKSkgZWxzZSBhcnJheS5zbGljZSgpXG4gICAgbmF0dXJhbE9yZGVyOiAoYSwgYikgLT5cbiAgICAgIGlmIGEgPCBiIHRoZW4gLTEgZWxzZSBpZiBhID4gYiB0aGVuIDEgZWxzZSAwXG4gICAgc3VtOiAoYXJyYXksIGYpIC0+XG4gICAgICBvID0ge31cbiAgICAgIGFycmF5LnJlZHVjZSBpZiBmIHRoZW4gKChwLCBkLCBpKSAtPlxuICAgICAgICBvLmluZGV4ID0gaVxuICAgICAgICBwICsgZi5jYWxsKG8sIGQpXG4gICAgICApIGVsc2UgKChwLCBkKSAtPlxuICAgICAgICBwICsgZFxuICAgICAgKVxuICAgIG1heDogKGFycmF5LCBmKSAtPlxuICAgICAgTWF0aC5tYXguYXBwbHkgbnVsbCwgaWYgZiB0aGVuIHB2Lm1hcChhcnJheSwgZikgZWxzZSBhcnJheVxuXG4jIyMqXG4jIEJhc2ljIEphdmFzY3JpcHQgcG9ydCBvZiB0aGUgTU1DUSAobW9kaWZpZWQgbWVkaWFuIGN1dCBxdWFudGl6YXRpb24pXG4jIGFsZ29yaXRobSBmcm9tIHRoZSBMZXB0b25pY2EgbGlicmFyeSAoaHR0cDovL3d3dy5sZXB0b25pY2EuY29tLykuXG4jIFJldHVybnMgYSBjb2xvciBtYXAgeW91IGNhbiB1c2UgdG8gbWFwIG9yaWdpbmFsIHBpeGVscyB0byB0aGUgcmVkdWNlZFxuIyBwYWxldHRlLiBTdGlsbCBhIHdvcmsgaW4gcHJvZ3Jlc3MuXG4jXG4jIEBhdXRob3IgTmljayBSYWJpbm93aXR6XG4jIEBleGFtcGxlXG5cbi8vIGFycmF5IG9mIHBpeGVscyBhcyBbUixHLEJdIGFycmF5c1xudmFyIG15UGl4ZWxzID0gW1sxOTAsMTk3LDE5MF0sIFsyMDIsMjA0LDIwMF0sIFsyMDcsMjE0LDIxMF0sIFsyMTEsMjE0LDIxMV0sIFsyMDUsMjA3LDIwN11cbiAgICAgICAgICAgICAgICAvLyBldGNcbiAgICAgICAgICAgICAgICBdO1xudmFyIG1heENvbG9ycyA9IDQ7XG5cbnZhciBjbWFwID0gTU1DUS5xdWFudGl6ZShteVBpeGVscywgbWF4Q29sb3JzKTtcbnZhciBuZXdQYWxldHRlID0gY21hcC5wYWxldHRlKCk7XG52YXIgbmV3UGl4ZWxzID0gbXlQaXhlbHMubWFwKGZ1bmN0aW9uKHApIHtcbiAgICByZXR1cm4gY21hcC5tYXAocCk7XG59KTtcblxuIyMjXG5cbk1NQ1EgPSBkbyAtPlxuICAjIHByaXZhdGUgY29uc3RhbnRzXG4gIHNpZ2JpdHMgPSA1XG4gIHJzaGlmdCA9IDggLSBzaWdiaXRzXG4gIG1heEl0ZXJhdGlvbnMgPSAxMDAwXG4gIGZyYWN0QnlQb3B1bGF0aW9ucyA9IDAuNzVcbiAgIyBnZXQgcmVkdWNlZC1zcGFjZSBjb2xvciBpbmRleCBmb3IgYSBwaXhlbFxuXG4gIGdldENvbG9ySW5kZXggPSAociwgZywgYikgLT5cbiAgICAociA8PCAyICogc2lnYml0cykgKyAoZyA8PCBzaWdiaXRzKSArIGJcblxuICAjIFNpbXBsZSBwcmlvcml0eSBxdWV1ZVxuXG4gIFBRdWV1ZSA9IChjb21wYXJhdG9yKSAtPlxuICAgIGNvbnRlbnRzID0gW11cbiAgICBzb3J0ZWQgPSBmYWxzZVxuXG4gICAgc29ydCA9IC0+XG4gICAgICBjb250ZW50cy5zb3J0IGNvbXBhcmF0b3JcbiAgICAgIHNvcnRlZCA9IHRydWVcbiAgICAgIHJldHVyblxuXG4gICAge1xuICAgICAgcHVzaDogKG8pIC0+XG4gICAgICAgIGNvbnRlbnRzLnB1c2ggb1xuICAgICAgICBzb3J0ZWQgPSBmYWxzZVxuICAgICAgICByZXR1cm5cbiAgICAgIHBlZWs6IChpbmRleCkgLT5cbiAgICAgICAgaWYgIXNvcnRlZFxuICAgICAgICAgIHNvcnQoKVxuICAgICAgICBpZiBgaW5kZXggPT0gdW5kZWZpbmVkYFxuICAgICAgICAgIGluZGV4ID0gY29udGVudHMubGVuZ3RoIC0gMVxuICAgICAgICBjb250ZW50c1tpbmRleF1cbiAgICAgIHBvcDogLT5cbiAgICAgICAgaWYgIXNvcnRlZFxuICAgICAgICAgIHNvcnQoKVxuICAgICAgICBjb250ZW50cy5wb3AoKVxuICAgICAgc2l6ZTogLT5cbiAgICAgICAgY29udGVudHMubGVuZ3RoXG4gICAgICBtYXA6IChmKSAtPlxuICAgICAgICBjb250ZW50cy5tYXAgZlxuICAgICAgZGVidWc6IC0+XG4gICAgICAgIGlmICFzb3J0ZWRcbiAgICAgICAgICBzb3J0KClcbiAgICAgICAgY29udGVudHNcblxuICAgIH1cblxuICAjIDNkIGNvbG9yIHNwYWNlIGJveFxuXG4gIFZCb3ggPSAocjEsIHIyLCBnMSwgZzIsIGIxLCBiMiwgaGlzdG8pIC0+XG4gICAgdmJveCA9IHRoaXNcbiAgICB2Ym94LnIxID0gcjFcbiAgICB2Ym94LnIyID0gcjJcbiAgICB2Ym94LmcxID0gZzFcbiAgICB2Ym94LmcyID0gZzJcbiAgICB2Ym94LmIxID0gYjFcbiAgICB2Ym94LmIyID0gYjJcbiAgICB2Ym94Lmhpc3RvID0gaGlzdG9cbiAgICByZXR1cm5cblxuICAjIENvbG9yIG1hcFxuXG4gIENNYXAgPSAtPlxuICAgIEB2Ym94ZXMgPSBuZXcgUFF1ZXVlKChhLCBiKSAtPlxuICAgICAgcHYubmF0dXJhbE9yZGVyIGEudmJveC5jb3VudCgpICogYS52Ym94LnZvbHVtZSgpLCBiLnZib3guY291bnQoKSAqIGIudmJveC52b2x1bWUoKVxuKVxuICAgIHJldHVyblxuXG4gICMgaGlzdG8gKDEtZCBhcnJheSwgZ2l2aW5nIHRoZSBudW1iZXIgb2YgcGl4ZWxzIGluXG4gICMgZWFjaCBxdWFudGl6ZWQgcmVnaW9uIG9mIGNvbG9yIHNwYWNlKSwgb3IgbnVsbCBvbiBlcnJvclxuXG4gIGdldEhpc3RvID0gKHBpeGVscykgLT5cbiAgICBoaXN0b3NpemUgPSAxIDw8IDMgKiBzaWdiaXRzXG4gICAgaGlzdG8gPSBuZXcgQXJyYXkoaGlzdG9zaXplKVxuICAgIGluZGV4ID0gdW5kZWZpbmVkXG4gICAgcnZhbCA9IHVuZGVmaW5lZFxuICAgIGd2YWwgPSB1bmRlZmluZWRcbiAgICBidmFsID0gdW5kZWZpbmVkXG4gICAgcGl4ZWxzLmZvckVhY2ggKHBpeGVsKSAtPlxuICAgICAgcnZhbCA9IHBpeGVsWzBdID4+IHJzaGlmdFxuICAgICAgZ3ZhbCA9IHBpeGVsWzFdID4+IHJzaGlmdFxuICAgICAgYnZhbCA9IHBpeGVsWzJdID4+IHJzaGlmdFxuICAgICAgaW5kZXggPSBnZXRDb2xvckluZGV4KHJ2YWwsIGd2YWwsIGJ2YWwpXG4gICAgICBoaXN0b1tpbmRleF0gPSAoaGlzdG9baW5kZXhdIG9yIDApICsgMVxuICAgICAgcmV0dXJuXG4gICAgaGlzdG9cblxuICB2Ym94RnJvbVBpeGVscyA9IChwaXhlbHMsIGhpc3RvKSAtPlxuICAgIHJtaW4gPSAxMDAwMDAwXG4gICAgcm1heCA9IDBcbiAgICBnbWluID0gMTAwMDAwMFxuICAgIGdtYXggPSAwXG4gICAgYm1pbiA9IDEwMDAwMDBcbiAgICBibWF4ID0gMFxuICAgIHJ2YWwgPSB1bmRlZmluZWRcbiAgICBndmFsID0gdW5kZWZpbmVkXG4gICAgYnZhbCA9IHVuZGVmaW5lZFxuICAgICMgZmluZCBtaW4vbWF4XG4gICAgcGl4ZWxzLmZvckVhY2ggKHBpeGVsKSAtPlxuICAgICAgcnZhbCA9IHBpeGVsWzBdID4+IHJzaGlmdFxuICAgICAgZ3ZhbCA9IHBpeGVsWzFdID4+IHJzaGlmdFxuICAgICAgYnZhbCA9IHBpeGVsWzJdID4+IHJzaGlmdFxuICAgICAgaWYgcnZhbCA8IHJtaW5cbiAgICAgICAgcm1pbiA9IHJ2YWxcbiAgICAgIGVsc2UgaWYgcnZhbCA+IHJtYXhcbiAgICAgICAgcm1heCA9IHJ2YWxcbiAgICAgIGlmIGd2YWwgPCBnbWluXG4gICAgICAgIGdtaW4gPSBndmFsXG4gICAgICBlbHNlIGlmIGd2YWwgPiBnbWF4XG4gICAgICAgIGdtYXggPSBndmFsXG4gICAgICBpZiBidmFsIDwgYm1pblxuICAgICAgICBibWluID0gYnZhbFxuICAgICAgZWxzZSBpZiBidmFsID4gYm1heFxuICAgICAgICBibWF4ID0gYnZhbFxuICAgICAgcmV0dXJuXG4gICAgbmV3IFZCb3gocm1pbiwgcm1heCwgZ21pbiwgZ21heCwgYm1pbiwgYm1heCwgaGlzdG8pXG5cbiAgbWVkaWFuQ3V0QXBwbHkgPSAoaGlzdG8sIHZib3gpIC0+XG5cbiAgICBkb0N1dCA9IChjb2xvcikgLT5cbiAgICAgIGRpbTEgPSBjb2xvciArICcxJ1xuICAgICAgZGltMiA9IGNvbG9yICsgJzInXG4gICAgICBsZWZ0ID0gdW5kZWZpbmVkXG4gICAgICByaWdodCA9IHVuZGVmaW5lZFxuICAgICAgdmJveDEgPSB1bmRlZmluZWRcbiAgICAgIHZib3gyID0gdW5kZWZpbmVkXG4gICAgICBkMiA9IHVuZGVmaW5lZFxuICAgICAgY291bnQyID0gMFxuICAgICAgYGkgPSB2Ym94W2RpbTFdYFxuICAgICAgd2hpbGUgaSA8PSB2Ym94W2RpbTJdXG4gICAgICAgIGlmIHBhcnRpYWxzdW1baV0gPiB0b3RhbCAvIDJcbiAgICAgICAgICB2Ym94MSA9IHZib3guY29weSgpXG4gICAgICAgICAgdmJveDIgPSB2Ym94LmNvcHkoKVxuICAgICAgICAgIGxlZnQgPSBpIC0gKHZib3hbZGltMV0pXG4gICAgICAgICAgcmlnaHQgPSB2Ym94W2RpbTJdIC0gaVxuICAgICAgICAgIGlmIGxlZnQgPD0gcmlnaHRcbiAgICAgICAgICAgIGQyID0gTWF0aC5taW4odmJveFtkaW0yXSAtIDEsIH4gfihpICsgcmlnaHQgLyAyKSlcbiAgICAgICAgICBlbHNlXG4gICAgICAgICAgICBkMiA9IE1hdGgubWF4KHZib3hbZGltMV0sIH4gfihpIC0gMSAtIChsZWZ0IC8gMikpKVxuICAgICAgICAgICMgYXZvaWQgMC1jb3VudCBib3hlc1xuICAgICAgICAgIHdoaWxlICFwYXJ0aWFsc3VtW2QyXVxuICAgICAgICAgICAgZDIrK1xuICAgICAgICAgIGNvdW50MiA9IGxvb2thaGVhZHN1bVtkMl1cbiAgICAgICAgICB3aGlsZSAhY291bnQyIGFuZCBwYXJ0aWFsc3VtW2QyIC0gMV1cbiAgICAgICAgICAgIGNvdW50MiA9IGxvb2thaGVhZHN1bVstLWQyXVxuICAgICAgICAgICMgc2V0IGRpbWVuc2lvbnNcbiAgICAgICAgICB2Ym94MVtkaW0yXSA9IGQyXG4gICAgICAgICAgdmJveDJbZGltMV0gPSB2Ym94MVtkaW0yXSArIDFcbiAgICAgICAgICAjICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZygndmJveCBjb3VudHM6JywgdmJveC5jb3VudCgpLCB2Ym94MS5jb3VudCgpLCB2Ym94Mi5jb3VudCgpKTtcbiAgICAgICAgICByZXR1cm4gW1xuICAgICAgICAgICAgdmJveDFcbiAgICAgICAgICAgIHZib3gyXG4gICAgICAgICAgXVxuICAgICAgICBpKytcbiAgICAgIHJldHVyblxuXG4gICAgaWYgIXZib3guY291bnQoKVxuICAgICAgcmV0dXJuXG4gICAgcncgPSB2Ym94LnIyIC0gKHZib3gucjEpICsgMVxuICAgIGd3ID0gdmJveC5nMiAtICh2Ym94LmcxKSArIDFcbiAgICBidyA9IHZib3guYjIgLSAodmJveC5iMSkgKyAxXG4gICAgbWF4dyA9IHB2Lm1heChbXG4gICAgICByd1xuICAgICAgZ3dcbiAgICAgIGJ3XG4gICAgXSlcbiAgICAjIG9ubHkgb25lIHBpeGVsLCBubyBzcGxpdFxuICAgIGlmIGB2Ym94LmNvdW50KCkgPT0gMWBcbiAgICAgIHJldHVybiBbIHZib3guY29weSgpIF1cblxuICAgICMjIyBGaW5kIHRoZSBwYXJ0aWFsIHN1bSBhcnJheXMgYWxvbmcgdGhlIHNlbGVjdGVkIGF4aXMuICMjI1xuXG4gICAgdG90YWwgPSAwXG4gICAgcGFydGlhbHN1bSA9IFtdXG4gICAgbG9va2FoZWFkc3VtID0gW11cbiAgICBpID0gdW5kZWZpbmVkXG4gICAgaiA9IHVuZGVmaW5lZFxuICAgIGsgPSB1bmRlZmluZWRcbiAgICBzdW0gPSB1bmRlZmluZWRcbiAgICBpbmRleCA9IHVuZGVmaW5lZFxuICAgIGlmIGBtYXh3ID09IHJ3YFxuICAgICAgaSA9IHZib3gucjFcbiAgICAgIHdoaWxlIGkgPD0gdmJveC5yMlxuICAgICAgICBzdW0gPSAwXG4gICAgICAgIGogPSB2Ym94LmcxXG4gICAgICAgIHdoaWxlIGogPD0gdmJveC5nMlxuICAgICAgICAgIGsgPSB2Ym94LmIxXG4gICAgICAgICAgd2hpbGUgayA8PSB2Ym94LmIyXG4gICAgICAgICAgICBpbmRleCA9IGdldENvbG9ySW5kZXgoaSwgaiwgaylcbiAgICAgICAgICAgIHN1bSArPSBoaXN0b1tpbmRleF0gb3IgMFxuICAgICAgICAgICAgaysrXG4gICAgICAgICAgaisrXG4gICAgICAgIHRvdGFsICs9IHN1bVxuICAgICAgICBwYXJ0aWFsc3VtW2ldID0gdG90YWxcbiAgICAgICAgaSsrXG4gICAgZWxzZSBpZiBgbWF4dyA9PSBnd2BcbiAgICAgIGkgPSB2Ym94LmcxXG4gICAgICB3aGlsZSBpIDw9IHZib3guZzJcbiAgICAgICAgc3VtID0gMFxuICAgICAgICBqID0gdmJveC5yMVxuICAgICAgICB3aGlsZSBqIDw9IHZib3gucjJcbiAgICAgICAgICBrID0gdmJveC5iMVxuICAgICAgICAgIHdoaWxlIGsgPD0gdmJveC5iMlxuICAgICAgICAgICAgaW5kZXggPSBnZXRDb2xvckluZGV4KGosIGksIGspXG4gICAgICAgICAgICBzdW0gKz0gaGlzdG9baW5kZXhdIG9yIDBcbiAgICAgICAgICAgIGsrK1xuICAgICAgICAgIGorK1xuICAgICAgICB0b3RhbCArPSBzdW1cbiAgICAgICAgcGFydGlhbHN1bVtpXSA9IHRvdGFsXG4gICAgICAgIGkrK1xuICAgIGVsc2VcblxuICAgICAgIyMjIG1heHcgPT0gYncgIyMjXG5cbiAgICAgIGkgPSB2Ym94LmIxXG4gICAgICB3aGlsZSBpIDw9IHZib3guYjJcbiAgICAgICAgc3VtID0gMFxuICAgICAgICBqID0gdmJveC5yMVxuICAgICAgICB3aGlsZSBqIDw9IHZib3gucjJcbiAgICAgICAgICBrID0gdmJveC5nMVxuICAgICAgICAgIHdoaWxlIGsgPD0gdmJveC5nMlxuICAgICAgICAgICAgaW5kZXggPSBnZXRDb2xvckluZGV4KGosIGssIGkpXG4gICAgICAgICAgICBzdW0gKz0gaGlzdG9baW5kZXhdIG9yIDBcbiAgICAgICAgICAgIGsrK1xuICAgICAgICAgIGorK1xuICAgICAgICB0b3RhbCArPSBzdW1cbiAgICAgICAgcGFydGlhbHN1bVtpXSA9IHRvdGFsXG4gICAgICAgIGkrK1xuICAgIHBhcnRpYWxzdW0uZm9yRWFjaCAoZCwgaSkgLT5cbiAgICAgIGxvb2thaGVhZHN1bVtpXSA9IHRvdGFsIC0gZFxuICAgICAgcmV0dXJuXG4gICAgIyBkZXRlcm1pbmUgdGhlIGN1dCBwbGFuZXNcbiAgICBpZiBgbWF4dyA9PSByd2AgdGhlbiBkb0N1dCgncicpIGVsc2UgaWYgYG1heHcgPT0gZ3dgIHRoZW4gZG9DdXQoJ2cnKSBlbHNlIGRvQ3V0KCdiJylcblxuICBxdWFudGl6ZSA9IChwaXhlbHMsIG1heGNvbG9ycykgLT5cbiAgICBrID0gMFxuICAgICMgc2hvcnQtY2lyY3VpdFxuICAgICMgaW5uZXIgZnVuY3Rpb24gdG8gZG8gdGhlIGl0ZXJhdGlvblxuXG4gICAgaXRlciA9IChsaCwgdGFyZ2V0KSAtPlxuICAgICAgbmNvbG9ycyA9IGxoLnNpemUoKVxuICAgICAgbml0ZXJzID0gMFxuICAgICAgdmJveCA9IHVuZGVmaW5lZFxuICAgICAgd2hpbGUgbml0ZXJzIDwgbWF4SXRlcmF0aW9uc1xuICAgICAgICBpZiBuY29sb3JzID49IHRhcmdldFxuICAgICAgICAgIHJldHVyblxuICAgICAgICBpZiBuaXRlcnMrKyA+IG1heEl0ZXJhdGlvbnNcbiAgICAgICAgICAjICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcImluZmluaXRlIGxvb3A7IHBlcmhhcHMgdG9vIGZldyBwaXhlbHMhXCIpO1xuICAgICAgICAgIHJldHVyblxuICAgICAgICB2Ym94ID0gbGgucG9wKClcbiAgICAgICAgaWYgIXZib3guY291bnQoKVxuXG4gICAgICAgICAgIyMjIGp1c3QgcHV0IGl0IGJhY2sgIyMjXG5cbiAgICAgICAgICBsaC5wdXNoIHZib3hcbiAgICAgICAgICBuaXRlcnMrK1xuICAgICAgICAgIGsrK1xuICAgICAgICAgIGNvbnRpbnVlXG4gICAgICAgICMgZG8gdGhlIGN1dFxuICAgICAgICB2Ym94ZXMgPSBtZWRpYW5DdXRBcHBseShoaXN0bywgdmJveClcbiAgICAgICAgdmJveDEgPSB2Ym94ZXNbMF1cbiAgICAgICAgdmJveDIgPSB2Ym94ZXNbMV1cbiAgICAgICAgaWYgIXZib3gxXG4gICAgICAgICAgIyAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJ2Ym94MSBub3QgZGVmaW5lZDsgc2hvdWxkbid0IGhhcHBlbiFcIik7XG4gICAgICAgICAgcmV0dXJuXG4gICAgICAgIGxoLnB1c2ggdmJveDFcbiAgICAgICAgaWYgdmJveDJcblxuICAgICAgICAgICMjIyB2Ym94MiBjYW4gYmUgbnVsbCAjIyNcblxuICAgICAgICAgIGxoLnB1c2ggdmJveDJcbiAgICAgICAgICBuY29sb3JzKytcbiAgICAgIHJldHVyblxuXG4gICAgaWYgIXBpeGVscy5sZW5ndGggb3IgbWF4Y29sb3JzIDwgMiBvciBtYXhjb2xvcnMgPiAyNTZcbiAgICAgICMgICAgICAgICAgICBjb25zb2xlLmxvZygnd3JvbmcgbnVtYmVyIG9mIG1heGNvbG9ycycpO1xuICAgICAgcmV0dXJuIGZhbHNlXG4gICAgIyBYWFg6IGNoZWNrIGNvbG9yIGNvbnRlbnQgYW5kIGNvbnZlcnQgdG8gZ3JheXNjYWxlIGlmIGluc3VmZmljaWVudFxuICAgIGhpc3RvID0gZ2V0SGlzdG8ocGl4ZWxzKVxuICAgIGhpc3Rvc2l6ZSA9IDEgPDwgMyAqIHNpZ2JpdHNcbiAgICAjIGNoZWNrIHRoYXQgd2UgYXJlbid0IGJlbG93IG1heGNvbG9ycyBhbHJlYWR5XG4gICAgbkNvbG9ycyA9IDBcbiAgICBoaXN0by5mb3JFYWNoIC0+XG4gICAgICBuQ29sb3JzKytcbiAgICAgIHJldHVyblxuICAgIGlmIG5Db2xvcnMgPD0gbWF4Y29sb3JzXG4gICAgICAjIFhYWDogZ2VuZXJhdGUgdGhlIG5ldyBjb2xvcnMgZnJvbSB0aGUgaGlzdG8gYW5kIHJldHVyblxuICAgIGVsc2VcbiAgICAjIGdldCB0aGUgYmVnaW5uaW5nIHZib3ggZnJvbSB0aGUgY29sb3JzXG4gICAgdmJveCA9IHZib3hGcm9tUGl4ZWxzKHBpeGVscywgaGlzdG8pXG4gICAgcHEgPSBuZXcgUFF1ZXVlKChhLCBiKSAtPlxuICAgICAgcHYubmF0dXJhbE9yZGVyIGEuY291bnQoKSwgYi5jb3VudCgpXG4pXG4gICAgcHEucHVzaCB2Ym94XG4gICAgIyBmaXJzdCBzZXQgb2YgY29sb3JzLCBzb3J0ZWQgYnkgcG9wdWxhdGlvblxuICAgIGl0ZXIgcHEsIGZyYWN0QnlQb3B1bGF0aW9ucyAqIG1heGNvbG9yc1xuICAgICMgUmUtc29ydCBieSB0aGUgcHJvZHVjdCBvZiBwaXhlbCBvY2N1cGFuY3kgdGltZXMgdGhlIHNpemUgaW4gY29sb3Igc3BhY2UuXG4gICAgcHEyID0gbmV3IFBRdWV1ZSgoYSwgYikgLT5cbiAgICAgIHB2Lm5hdHVyYWxPcmRlciBhLmNvdW50KCkgKiBhLnZvbHVtZSgpLCBiLmNvdW50KCkgKiBiLnZvbHVtZSgpXG4pXG4gICAgd2hpbGUgcHEuc2l6ZSgpXG4gICAgICBwcTIucHVzaCBwcS5wb3AoKVxuICAgICMgbmV4dCBzZXQgLSBnZW5lcmF0ZSB0aGUgbWVkaWFuIGN1dHMgdXNpbmcgdGhlIChucGl4ICogdm9sKSBzb3J0aW5nLlxuICAgIGl0ZXIgcHEyLCBtYXhjb2xvcnNcbiAgICAjIGNhbGN1bGF0ZSB0aGUgYWN0dWFsIGNvbG9yc1xuICAgIGNtYXAgPSBuZXcgQ01hcFxuICAgIHdoaWxlIHBxMi5zaXplKClcbiAgICAgIGNtYXAucHVzaCBwcTIucG9wKClcbiAgICBjbWFwXG5cbiAgVkJveC5wcm90b3R5cGUgPVxuICAgIHZvbHVtZTogKGZvcmNlKSAtPlxuICAgICAgdmJveCA9IHRoaXNcbiAgICAgIGlmICF2Ym94Ll92b2x1bWUgb3IgZm9yY2VcbiAgICAgICAgdmJveC5fdm9sdW1lID0gKHZib3gucjIgLSAodmJveC5yMSkgKyAxKSAqICh2Ym94LmcyIC0gKHZib3guZzEpICsgMSkgKiAodmJveC5iMiAtICh2Ym94LmIxKSArIDEpXG4gICAgICB2Ym94Ll92b2x1bWVcbiAgICBjb3VudDogKGZvcmNlKSAtPlxuICAgICAgdmJveCA9IHRoaXNcbiAgICAgIGhpc3RvID0gdmJveC5oaXN0b1xuICAgICAgaWYgIXZib3guX2NvdW50X3NldCBvciBmb3JjZVxuICAgICAgICBucGl4ID0gMFxuICAgICAgICBpID0gdW5kZWZpbmVkXG4gICAgICAgIGogPSB1bmRlZmluZWRcbiAgICAgICAgayA9IHVuZGVmaW5lZFxuICAgICAgICBpID0gdmJveC5yMVxuICAgICAgICB3aGlsZSBpIDw9IHZib3gucjJcbiAgICAgICAgICBqID0gdmJveC5nMVxuICAgICAgICAgIHdoaWxlIGogPD0gdmJveC5nMlxuICAgICAgICAgICAgayA9IHZib3guYjFcbiAgICAgICAgICAgIHdoaWxlIGsgPD0gdmJveC5iMlxuICAgICAgICAgICAgICBgaW5kZXggPSBnZXRDb2xvckluZGV4KGksIGosIGspYFxuICAgICAgICAgICAgICBucGl4ICs9IGhpc3RvW2luZGV4XSBvciAwXG4gICAgICAgICAgICAgIGsrK1xuICAgICAgICAgICAgaisrXG4gICAgICAgICAgaSsrXG4gICAgICAgIHZib3guX2NvdW50ID0gbnBpeFxuICAgICAgICB2Ym94Ll9jb3VudF9zZXQgPSB0cnVlXG4gICAgICB2Ym94Ll9jb3VudFxuICAgIGNvcHk6IC0+XG4gICAgICB2Ym94ID0gdGhpc1xuICAgICAgbmV3IFZCb3godmJveC5yMSwgdmJveC5yMiwgdmJveC5nMSwgdmJveC5nMiwgdmJveC5iMSwgdmJveC5iMiwgdmJveC5oaXN0bylcbiAgICBhdmc6IChmb3JjZSkgLT5cbiAgICAgIHZib3ggPSB0aGlzXG4gICAgICBoaXN0byA9IHZib3guaGlzdG9cbiAgICAgIGlmICF2Ym94Ll9hdmcgb3IgZm9yY2VcbiAgICAgICAgbnRvdCA9IDBcbiAgICAgICAgbXVsdCA9IDEgPDwgOCAtIHNpZ2JpdHNcbiAgICAgICAgcnN1bSA9IDBcbiAgICAgICAgZ3N1bSA9IDBcbiAgICAgICAgYnN1bSA9IDBcbiAgICAgICAgaHZhbCA9IHVuZGVmaW5lZFxuICAgICAgICBpID0gdW5kZWZpbmVkXG4gICAgICAgIGogPSB1bmRlZmluZWRcbiAgICAgICAgayA9IHVuZGVmaW5lZFxuICAgICAgICBoaXN0b2luZGV4ID0gdW5kZWZpbmVkXG4gICAgICAgIGkgPSB2Ym94LnIxXG4gICAgICAgIHdoaWxlIGkgPD0gdmJveC5yMlxuICAgICAgICAgIGogPSB2Ym94LmcxXG4gICAgICAgICAgd2hpbGUgaiA8PSB2Ym94LmcyXG4gICAgICAgICAgICBrID0gdmJveC5iMVxuICAgICAgICAgICAgd2hpbGUgayA8PSB2Ym94LmIyXG4gICAgICAgICAgICAgIGhpc3RvaW5kZXggPSBnZXRDb2xvckluZGV4KGksIGosIGspXG4gICAgICAgICAgICAgIGh2YWwgPSBoaXN0b1toaXN0b2luZGV4XSBvciAwXG4gICAgICAgICAgICAgIG50b3QgKz0gaHZhbFxuICAgICAgICAgICAgICByc3VtICs9IGh2YWwgKiAoaSArIDAuNSkgKiBtdWx0XG4gICAgICAgICAgICAgIGdzdW0gKz0gaHZhbCAqIChqICsgMC41KSAqIG11bHRcbiAgICAgICAgICAgICAgYnN1bSArPSBodmFsICogKGsgKyAwLjUpICogbXVsdFxuICAgICAgICAgICAgICBrKytcbiAgICAgICAgICAgIGorK1xuICAgICAgICAgIGkrK1xuICAgICAgICBpZiBudG90XG4gICAgICAgICAgdmJveC5fYXZnID0gW1xuICAgICAgICAgICAgfiB+KHJzdW0gLyBudG90KVxuICAgICAgICAgICAgfiB+KGdzdW0gLyBudG90KVxuICAgICAgICAgICAgfiB+KGJzdW0gLyBudG90KVxuICAgICAgICAgIF1cbiAgICAgICAgZWxzZVxuICAgICAgICAgICMgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKCdlbXB0eSBib3gnKTtcbiAgICAgICAgICB2Ym94Ll9hdmcgPSBbXG4gICAgICAgICAgICB+IH4obXVsdCAqICh2Ym94LnIxICsgdmJveC5yMiArIDEpIC8gMilcbiAgICAgICAgICAgIH4gfihtdWx0ICogKHZib3guZzEgKyB2Ym94LmcyICsgMSkgLyAyKVxuICAgICAgICAgICAgfiB+KG11bHQgKiAodmJveC5iMSArIHZib3guYjIgKyAxKSAvIDIpXG4gICAgICAgICAgXVxuICAgICAgdmJveC5fYXZnXG4gICAgY29udGFpbnM6IChwaXhlbCkgLT5cbiAgICAgIHZib3ggPSB0aGlzXG4gICAgICBydmFsID0gcGl4ZWxbMF0gPj4gcnNoaWZ0XG4gICAgICBgZ3ZhbCA9IHBpeGVsWzFdID4+IHJzaGlmdGBcbiAgICAgIGBidmFsID0gcGl4ZWxbMl0gPj4gcnNoaWZ0YFxuICAgICAgcnZhbCA+PSB2Ym94LnIxIGFuZCBydmFsIDw9IHZib3gucjIgYW5kIGd2YWwgPj0gdmJveC5nMSBhbmQgZ3ZhbCA8PSB2Ym94LmcyIGFuZCBidmFsID49IHZib3guYjEgYW5kIGJ2YWwgPD0gdmJveC5iMlxuICBDTWFwLnByb3RvdHlwZSA9XG4gICAgcHVzaDogKHZib3gpIC0+XG4gICAgICBAdmJveGVzLnB1c2hcbiAgICAgICAgdmJveDogdmJveFxuICAgICAgICBjb2xvcjogdmJveC5hdmcoKVxuICAgICAgcmV0dXJuXG4gICAgcGFsZXR0ZTogLT5cbiAgICAgIEB2Ym94ZXMubWFwICh2YikgLT5cbiAgICAgICAgdmIuY29sb3JcbiAgICBzaXplOiAtPlxuICAgICAgQHZib3hlcy5zaXplKClcbiAgICBtYXA6IChjb2xvcikgLT5cbiAgICAgIHZib3hlcyA9IEB2Ym94ZXNcbiAgICAgIGkgPSAwXG4gICAgICB3aGlsZSBpIDwgdmJveGVzLnNpemUoKVxuICAgICAgICBpZiB2Ym94ZXMucGVlayhpKS52Ym94LmNvbnRhaW5zKGNvbG9yKVxuICAgICAgICAgIHJldHVybiB2Ym94ZXMucGVlayhpKS5jb2xvclxuICAgICAgICBpKytcbiAgICAgIEBuZWFyZXN0IGNvbG9yXG4gICAgbmVhcmVzdDogKGNvbG9yKSAtPlxuICAgICAgdmJveGVzID0gQHZib3hlc1xuICAgICAgZDEgPSB1bmRlZmluZWRcbiAgICAgIGQyID0gdW5kZWZpbmVkXG4gICAgICBwQ29sb3IgPSB1bmRlZmluZWRcbiAgICAgIGkgPSAwXG4gICAgICB3aGlsZSBpIDwgdmJveGVzLnNpemUoKVxuICAgICAgICBkMiA9IE1hdGguc3FydCgoY29sb3JbMF0gLSAodmJveGVzLnBlZWsoaSkuY29sb3JbMF0pKSAqKiAyICsgKGNvbG9yWzFdIC0gKHZib3hlcy5wZWVrKGkpLmNvbG9yWzFdKSkgKiogMiArIChjb2xvclsyXSAtICh2Ym94ZXMucGVlayhpKS5jb2xvclsyXSkpICoqIDIpXG4gICAgICAgIGlmIGQyIDwgZDEgb3IgYGQxID09IHVuZGVmaW5lZGBcbiAgICAgICAgICBkMSA9IGQyXG4gICAgICAgICAgcENvbG9yID0gdmJveGVzLnBlZWsoaSkuY29sb3JcbiAgICAgICAgaSsrXG4gICAgICBwQ29sb3JcbiAgICBmb3JjZWJ3OiAtPlxuICAgICAgIyBYWFg6IHdvbid0ICB3b3JrIHlldFxuICAgICAgdmJveGVzID0gQHZib3hlc1xuICAgICAgdmJveGVzLnNvcnQgKGEsIGIpIC0+XG4gICAgICAgIHB2Lm5hdHVyYWxPcmRlciBwdi5zdW0oYS5jb2xvciksIHB2LnN1bShiLmNvbG9yKVxuICAgICAgIyBmb3JjZSBkYXJrZXN0IGNvbG9yIHRvIGJsYWNrIGlmIGV2ZXJ5dGhpbmcgPCA1XG4gICAgICBsb3dlc3QgPSB2Ym94ZXNbMF0uY29sb3JcbiAgICAgIGlmIGxvd2VzdFswXSA8IDUgYW5kIGxvd2VzdFsxXSA8IDUgYW5kIGxvd2VzdFsyXSA8IDVcbiAgICAgICAgdmJveGVzWzBdLmNvbG9yID0gW1xuICAgICAgICAgIDBcbiAgICAgICAgICAwXG4gICAgICAgICAgMFxuICAgICAgICBdXG4gICAgICAjIGZvcmNlIGxpZ2h0ZXN0IGNvbG9yIHRvIHdoaXRlIGlmIGV2ZXJ5dGhpbmcgPiAyNTFcbiAgICAgIGlkeCA9IHZib3hlcy5sZW5ndGggLSAxXG4gICAgICBoaWdoZXN0ID0gdmJveGVzW2lkeF0uY29sb3JcbiAgICAgIGlmIGhpZ2hlc3RbMF0gPiAyNTEgYW5kIGhpZ2hlc3RbMV0gPiAyNTEgYW5kIGhpZ2hlc3RbMl0gPiAyNTFcbiAgICAgICAgdmJveGVzW2lkeF0uY29sb3IgPSBbXG4gICAgICAgICAgMjU1XG4gICAgICAgICAgMjU1XG4gICAgICAgICAgMjU1XG4gICAgICAgIF1cbiAgICAgIHJldHVyblxuICB7IHF1YW50aXplOiBxdWFudGl6ZSB9XG5cbiMgLS0tXG4jIGdlbmVyYXRlZCBieSBqczJjb2ZmZWUgMi4yLjAiLCIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUVBQTs7QURzQkE7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFnQ0E7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBa0JBOzs7Ozs7QUFsREEsSUFBQTs7QUF5REEsV0FBQSxHQUFjLFNBQUMsS0FBRDtFQUNaLElBQUMsQ0FBQSxNQUFELEdBQVUsUUFBUSxDQUFDLGFBQVQsQ0FBdUIsUUFBdkI7RUFDVixJQUFDLENBQUEsT0FBRCxHQUFXLElBQUMsQ0FBQSxNQUFNLENBQUMsVUFBUixDQUFtQixJQUFuQjtFQUNYLFFBQVEsQ0FBQyxJQUFJLENBQUMsV0FBZCxDQUEwQixJQUFDLENBQUEsTUFBM0I7RUFDQSxJQUFDLENBQUEsS0FBRCxHQUFTLElBQUMsQ0FBQSxNQUFNLENBQUMsS0FBUixHQUFnQixLQUFLLENBQUM7RUFDL0IsSUFBQyxDQUFBLE1BQUQsR0FBVSxJQUFDLENBQUEsTUFBTSxDQUFDLE1BQVIsR0FBaUIsS0FBSyxDQUFDO0VBQ2pDLElBQUMsQ0FBQSxPQUFPLENBQUMsU0FBVCxDQUFtQixLQUFuQixFQUEwQixDQUExQixFQUE2QixDQUE3QixFQUFnQyxJQUFDLENBQUEsS0FBakMsRUFBd0MsSUFBQyxDQUFBLE1BQXpDO0FBTlk7O0FBU2QsV0FBVyxDQUFBLFNBQUUsQ0FBQSxLQUFiLEdBQXFCLFNBQUE7RUFDbkIsSUFBQyxDQUFBLE9BQU8sQ0FBQyxTQUFULENBQW1CLENBQW5CLEVBQXNCLENBQXRCLEVB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
