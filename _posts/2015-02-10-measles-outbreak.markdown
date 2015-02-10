---
layout: post
title:  "Measles Outbreak"
date:   2015-02-10 12:00:00
categories: d3 javascript
---


Goal is to show where the outbreak is, and where the likely concentration of folks that aren't vaccinating are based on this.

I realize some of these poor parents have been infected by other kids, particularly from places like disneyworld.  However, the CDC data also shows there is likely a correlations between areas with a concentration of these issues and bad parents ignoring science.


<div id="map-target" style="height: 500px">

</div>

Oh wait, its basically just california. Thanks California.

<script src="/js/d3.v3.min.js"></script>
<script src="/js/topojson.min.js"></script>
<script src="/js/datamaps.min.js"></script>
<script>
  var data = {"AZ":{"cases":"7","fillKey":"MEDIUM"},"CA":{"cases":"88","fillKey":"HIGH"},"CO":{"cases":"1","fillKey":"LOW"},"DC":{"cases":"1","fillKey":"LOW"},"DE":{"cases":"1","fillKey":"LOW"},"IL":{"cases":"3","fillKey":"MEDIUM"},"MI":{"cases":"1","fillKey":"LOW"},"MN":{"cases":"1","fillKey":"LOW"},"NE":{"cases":"2","fillKey":"MEDIUM"},"NJ":{"cases":"1","fillKey":"LOW"},"NY":{"cases":"2","fillKey":"MEDIUM"},"NV":{"cases":"2","fillKey":"MEDIUM"},"OR":{"cases":"1","fillKey":"LOW"},"PA":{"cases":"1","fillKey":"LOW"},"SD":{"cases":"2","fillKey":"MEDIUM"},"UT":{"cases":"2","fillKey":"MEDIUM"},"WA":{"cases":"4","fillKey":"MEDIUM"}};
  var map = new Datamap({
        element: document.getElementById('map-target'),
        scope: 'usa',
        fills: {
            HIGH: 'red',
            LOW: 'yellow',
            MEDIUM: 'orange',
            UNKNOWN: 'rgb(0,0,0)',
            defaultFill: 'grey'
        },
        data: data,
        geographyConfig: {
            popupTemplate: function(geo, data) {
                if(data){
                    return ['<div class="hoverinfo"><strong>',
                        'Number of cases in ' + geo.properties.name,
                        ': ' + data.cases,
                        '</strong></div>'].join('');
                }else{
                    return "";
                }
            }
        }
    });

</script>