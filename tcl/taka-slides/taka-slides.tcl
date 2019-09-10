#!/usr/bin/tclsh

proc getWithoutFirstCh {string} {
	return [string trim [string range $string 1 [string length $string]]]
}

set firstPart {
	<!DOCTYPE html>
<html>
<head>
	<title>Slides</title>
	<style>
		html, body, #container {
			padding: 0;
			margin: 0;
		}
		body {
			font-family: 'Helvetica Neue', Helvetica, Arial, freesans, clean, sans-serif;
			background-color: #ef8d24;
			color: #ffffff;
		}
		#container {
			display: table;
		    position: absolute;
		    top: 0;
		    left: 0;
		    width: 100%;
		    height: 100%;
			align-items: center;
		    justify-content: center;
		    overflow: hidden;
		}
		.content {
			display: table-cell;
			text-align: center;
			vertical-align: middle;
			width: 100%;
		}
	</style>
	<script type="text/javascript">
		/*!	
		* FitText.js 1.0 jQuery free version
		*
		* Copyright 2011, Dave Rupert http://daverupert.com 
		* Released under the WTFPL license 
		* http://sam.zoy.org/wtfpl/
		* Modified by Slawomir Kolodziej http://slawekk.info
		*
		* Date: Tue Aug 09 2011 10:45:54 GMT+0200 (CEST)
		*/
		(function(){

		  var addEvent = function (el, type, fn) {
		    if (el.addEventListener)
		      el.addEventListener(type, fn, false);
				else
					el.attachEvent('on'+type, fn);
		  };
		  
		  var extend = function(obj,ext){
		    for(var key in ext)
		      if(ext.hasOwnProperty(key))
		        obj[key] = ext[key];
		    return obj;
		  };

		  window.fitText = function (el, kompressor, options) {

		    var settings = extend({
		      'minFontSize' : -1/0,
		      'maxFontSize' : 1/0
		    },options);

		    var fit = function (el) {
		      var compressor = kompressor || 1;

		      var resizer = function () {
		        el.style.fontSize = Math.max(Math.min(el.clientWidth / (compressor*10), parseFloat(settings.maxFontSize)), parseFloat(settings.minFontSize)) + 'px';
		      };

		      // Call once to set.
		      resizer();

		      // Bind events
		      // If you have any js library which support Events, replace this part
		      // and remove addEvent function (or use original jQuery version)
		      addEvent(window, 'resize', resizer);
		      addEvent(window, 'orientationchange', resizer);
		    };

		    if (el.length)
		      for(var i=0; i<el.length; i++)
		        fit(el[i]);
		    else
		      fit(el);

		    // return set of elements
		    return el;
		  };
		})();
		(function(){
			var ctx = {
				slides: [],
				num: 0
			};
			window.onload = function(){
				// fitText(document.getElementsByClassName('content'), 1.2);
				ctx.slides = document.getElementsByClassName('content');
				for(var i=0; i<ctx.slides.length; i++) {
					ctx.slides[i].style.display = 'none';
				}

				function show(num){
					ctx.slides[ctx.num].style.display = 'none';
					ctx.num = num;
					ctx.slides[ctx.num].style.display = 'table-cell';

					fitText(ctx.slides[ctx.num], 1.2);
				}

				show(0);

				window.addEventListener("keydown", function(event) {
					switch (event.key) {
						case 'ArrowRight':
						case 'ArrowDown':
						case 'PageDown':
							show(ctx.num === ctx.slides.length - 1 ? 0 : ctx.num + 1);
							break;
						case 'ArrowLeft':
						case 'ArrowUp':
						case 'PageUp':
							show(ctx.num === 0 ? ctx.slides.length - 1 : ctx.num - 1);
							break;
						case 'Home':
							show(0);
							break;
						case 'End':
							show(ctx.slides.length - 1);
							break;
						default: break;
					}
				});
			}
		})();
	</script>
</head>
<body>
	<div id="container">
}

set secondPart {
	</div>
</body>
</html>
}

lassign $argv sourceFile

set inp [open $sourceFile]
set source [read $inp]
close $inp

set data {}
set prevBlank false

# Text normalization
foreach line [split $source \n] {
	set line [string trim $line]

	if {[string length $line] == 0} {
		if {[llength $data] == 0 || $prevBlank} {
			continue
		} else {
			lappend data $line
			set prevBlank true
		}
	} else {
		if {[string first \# $line] != 0} {
			lappend data $line
		}
		set prevBlank false
	}
}

# Text processing
set slides {}
set slide {}
set prevList false
foreach line $data {
	if {[string first \- $line] == 0} {
		if {!$prevList} {
			set prevList true
			lappend slide <ul>
		}

		set item [getWithoutFirstCh $line]
		lappend slide "<li>$item</li/>"
		continue
	}

	if {$prevList} {
		set prevList false
		lappend slide </ul>
	}

	if {[string length $line] == 0} {
		lappend slides [join $slide \n]
		set slide {}
	}

	if {[string first \@ $line] == 0} {
		set url [getWithoutFirstCh $line]
		lappend slide "<img src=\"$url\" />"
		continue
	}

	if {[string first \\ $line] == 0} {
		set rest [getWithoutFirstCh $line]
		lappend slide "$rest<br/>"
		continue
	}

	lappend slide "$line<br/>"
}
lappend slides [join $slide \n]


puts [append html $firstPart {<div class="content">} \n [join $slides "\n</div>\n<div class=\"content\">"] \n</div> $secondPart]