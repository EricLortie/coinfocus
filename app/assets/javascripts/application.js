// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require chart
//= require moment
//= require moment-timezone-with-data
//= require_tree .
//= require_tree ./channels

//
// $(document).on('ready', function(){
//
//   // $('.coinRow').on('click', function(){
//   //   window.location.href = `/coins/${$(this).attr('coin-id')}`;
//   // })
//
// });

function getRandomColor() {
  var letters = '0123456789ABCDEF';
  var color = '#';
  for (var i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

function fetch_bg_colors(count) {
  ret = []
  for (var i = 0; i <= count; i++) {
    ret.push(getRandomColor());
  }
  return ret;
}
function timeSince(date) {

  var seconds = Math.floor((new Date() - date) / 1000);
  var interval = Math.floor(seconds / 31536000);

  if (interval > 1) {
    return interval + " years";
  }
  interval = Math.floor(seconds / 2592000);
  if (interval > 1) {
    return interval + " months";
  }
  interval = Math.floor(seconds / 86400);
  if (interval > 1) {
    return interval + " days";
  }
  interval = Math.floor(seconds / 3600);
  if (interval > 1) {
    return interval + " hours";
  }
  interval = Math.floor(seconds / 60);
  if (interval > 1) {
    return interval + " minutes";
  }
  return Math.floor(seconds) + " seconds";
}
//register custome positioner
Chart.Tooltip.positioners.custom = function(elements, position) {
  if (!elements.length) {
    return false;
  }
  var offset = 0;
  //adjust the offset left or right depending on the event position
  if (elements[0]._chart.width / 2 > position.x) {
    offset = 20;
  } else {
    offset = -20;
  }
  return {
    x: position.x + offset,
    y: position.y
  }
}

Chart.defaults.global.pointHitDetectionRadius = 1;
var customTooltip = function(tooltip) {

	$(this._chart.canvas).css("cursor", "pointer");
	$(".chartjs-tooltip").css({
		opacity: 0,
	});
	if (!tooltip || !tooltip.opacity) {
		return;
	}
	if (tooltip.dataPoints.length > 0) {


    function getBody(bodyItem) {
        return bodyItem.lines;
    }
		tooltip.dataPoints.forEach(function (dataPoint) {

      var $tooltip = $("#tooltip-" + dataPoint.datasetIndex);
      if (!$tooltip) {
          alert("No tooltip for " + dataPoint.datasetIndex);
      }

      if (tooltip.body) {
        var titleLines = tooltip.title || [];
        var bodyLines = tooltip.body.map(getBody);
        console.log(tooltip);
        //PUT CUSTOM HTML TOOLTIP CONTENT HERE (innerHTML)
        var innerHtml = '<table><thead>';
        titleLines.forEach(function(title) {
            innerHtml += '<tr><th>' + `${timeSince(title)} ago` + '</th>';
        });
        bodyLines.forEach(function(body, i) {
            var colors = tooltip.labelColors[i];
            var style = 'background:' + colors.backgroundColor;
            style += '; border-color:' + colors.borderColor;
            style += '; border-width: 2px';
            var span = '<span class="chartjs-tooltip-key" style="' + style + '"></span>';
            innerHtml += '<th>' + span + body + '</th>';
        });
        innerHtml += '</tr></thead></tbody></table>';
      }
			$('#tooltip-section').html(innerHtml);
		});
	}


};

