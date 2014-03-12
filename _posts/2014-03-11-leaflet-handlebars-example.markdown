---
layout: post
title:  "Leaflet, Handlebars, Simple Map Application"
date:   2014-03-11 15:30:00
categories: leaflet handlebars javascript
---

We often need interactive maps to make geographically tied data more useful to the public.  We decided to publish as part of our example applications, a stripped down version of an application to showcase some basic javascript tools and their usage internally and for whoever may be itnerested.  This example application is based off work done on [HHS Flu Vaccination Map](http://www.hhs.gov/nvpo/flu-vaccination-map/) and other applications.

## Getting the Code

The code is available on [<i class="fa fa-github-alt">Github</i>](https://github.com/ctacdev/examples-leaflet_handlebars)

Check it out using the command below:
{% highlight bash table %}
  git clone git@github.com:ctacdev/examples-leaflet_handlebars.git
{% endhighlight %}

Particular important files, these are where most of the magic happens:
{% highlight bash table %}
  index.html
  /javascript/main.js
{% endhighlight %}

## Major Libraries

There are a few major libraries used (some for rather minor things in this stripped down version)

* [Leaflet](http://leafletjs.com/) - Leaflet is a modern open-source JavaScript library for mobile-friendly interactive maps.
* [Handlebars](http://handlebarsjs.com/) - Handlebars provides the power necessary to let you build semantic templates effectively with no frustration.
* [Underscore](http://underscorejs.org/) - Underscore provides 80-odd functions that support both the usual functional suspects: map, select, invoke — as well as more specialized helpers: function binding, javascript templating, deep equality testing, and so on.
* [jQuery](http://jquery.com/) - jQuery is a fast, small, and feature-rich JavaScript library.

## The Code

I won't cover all of the HTML and javascript, just the key parts.  Some of the code is defintely not in "perfect form", its meant to serve as how you can achieve some basic goals.

### The Scaffold
First, lets scaffold out the html that our app will reside in:
{% highlight html linenos %}
<div class="container">
  <div class="row">
    <div class="col-xs-12">
      <h1>Leaflet / Handlebars Demo</h1>
    </div>
  </div>
  <div class="row">
    <div class="col-xs-12">
      <h2>Map</h2>
    </div>
    <div class="col-xs-12" id="map">
    </div>
  </div>
  <div class="row">
    <div class="col-xs-12">
      <h2>Table</h2>
    </div>
    <div class="col-xs-12" id="table_container">
    </div>
  </div>
</div>
{% endhighlight %}

### Grabbing the data, starting the application

Now, lets grab the data that powers the application:  This data will be used to render everything in the application.
{% highlight javascript linenos table %}
function start(){
  $.getJSON("data/state_geo.json",function(us_states){
    $.getJSON("data/state_data.json",function(data){
      states_geo_json= us_states;
      states_data = data.results;
      initialize_map();
      draw_states();
    })
  });
}
{% endhighlight %}

### Map Initialization (Leaflet)

Now lets initialize our Leaflet.  Leaflet makes it really easy to create a basic map with OpenStreetMap tile layers.
{% highlight javascript linenos table %}
/* Create map, center it */
function initialize_map(){
  map = new L.Map("map", {})
    // Lebanon, KS, Zoom level 4.
    .setView(new L.LatLng(37.8, -96.9), 4)
    .addLayer(new L.TileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',{
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }));
  initialize_info_box();
  initialize_legend();
  intialize_reset_button();
  initialize_table();
}
{% endhighlight %}

### The Info Box (Leaflet / Handlebars)

The info box lifes in the top right portion of the map.  If no state is being hovered over, it should display a message about hovering over a state.  When hovering over a state, we should show information from that state.

Here we see where handlebars shines.  Handlebars pulls in a template and uses it to
render HTML based on javascript data as a context.  This allows us to send a data element
to the update method, and have handlebars handle rendering what needs to be rendered into the inf box.

Leaflet (from javascript/main.js):
{% highlight javascript linenos table %}
// Initializes the info box, which uses a handlebars template
function initialize_info_box(){
  info = L.control();
  // Prepare Template
  var info_source   = $("#info_template").html();
  var info_template = Handlebars.compile(info_source);
  info.onAdd = function (map) {
    this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
    this.update({});
    return this._div;
  };
  info.update = function (context) {
    this._div.innerHTML = info_template(context);
  };
  info.addTo(map);
}
{% endhighlight %}
Handlebars (from index.html):
{% highlight javascript linenos table %}
{% raw %}
<script id="info_template" type="text/x-handlebars-template">
  <div>
    <p>Vaccination Claims Rate</p>
    {{#if name}}
      <p>{{name}}</p>
      {{#if count}}
      <p>Beneiciaries: {{count}}</p>
      {{/if}}
      {{#if percentage}}
      <p>Rate: {{percentage}}</p>
      {{/if}}
    {{else}}
      <p>Hover over a region for data.</p>
    {{/if}}
  </div>
</script>
{% endraw %}
{% endhighlight %}

### Initialize the Table (Handlebars)

Our table is initialized with the full data set.  This showcases handlebars ability to output large amounts of data using looping structures.

Handlebars Template:
{% highlight html linenos table %}
{% raw %}
<script id="table_template" type="text/x-handlebars-template">
  <table class="table table-striped table-bordered" id="states_table">
    <tbody>
      <tr>
        <th scope="col">State Name</th>
        <th scope="col">Beneficiaries</th>
        <th scope="col">Rate</th>
      </tr>
      {{#each this}}
        <tr>
          <th scope="row">{{name}}</th>
          <td>{{count}}</td>
          <td>{{percentage}}</td>
        </tr>
      {{/each}}
    </tbody>
  </table>
</script>
{% endraw %}
{% endhighlight %}

Javascript:
{% highlight javascript linenos table %}
/* Initializes a table, uses handlebars to fill in data */
function initialize_table(){
  table = $('#table_container');
  var table_source = $("#table_template").html();
  var table_template = Handlebars.compile(table_source);
  table.html(table_template(states_data));
}
{% endhighlight %}

### Drawing Our Colored Polygons

Finally, we really would like to draw our polygons on the map.  This is done using Leaflet, and a group of functions that parse our data set.  Check out the comments for more information

{% highlight javascript linenos table %}
// Draw all the states on the map
function draw_states(){
  state_layer = L.geoJson(states_geo_json,{
    style: state_styles,
    onEachFeature: state_features,
    updateWhenIdle: true
  });
  state_layer.addTo(map);
}

// Styles each state, populates color based on data
function state_styles(feature){
  return{
    stroke: true,
    fillColor: state_color(feature),
    fillOpacity: 0.7,
    weight: 1.5,
    opacity: 1,
    color: 'black',
    zIndex: 15
  };
}
// Gets the color based on percentage
function state_color(feature){
  var state = get_single_state_data(feature.properties.name);
  return color_picker(state['percentage']);
}
// Returns a single states data by filtering for abbreviation
function get_single_state_data(state_name){
  var local_states = states_data.filter(function(item){return item.name == state_name});
  return local_states[0];
}
/*
 * Color Picker picks a color from a data array,
 * could use a library if so desired
 */
function color_picker(percentage){
  var bucket = Math.floor(percentage * 10);
  if(color_array[bucket]!= null){
    return color_array[bucket];
  }else{
    return "rgb(0,0,0)";
  }
}

// set up state features (such as on click events and others)
function state_features(feature, layer){
  // this sets all the data needed for the hover info window. will refactor later
  function state_info_window(state){
    var this_states_data = get_single_state_data(feature.properties.name);
    info.update(this_states_data);
  }
  // change the state styles so its highlighted with a gray border for now
  function highlightState(e) {
    var layer = e.target;
    layer.setStyle({
      weight: 5, color: '#666', dashArray: '', fillOpacity: 0.7
    });
  }
  // disable highlight by using reset style
  function resetHighlightState(e) {
    state_layer.resetStyle(e.target);
  }
  // add click, mouseover, and mouseout interactions to state
  layer.on({
    click: function(){
      map.fitBounds(layer.getBounds());
      // Here we could something interesting, like grab county data
      // change styles, whatever we'd be interested in
    },
    // set data for info window, highlight
    mouseover: function(e){
      state_info_window(feature.properties.name)
      highlightState(e);
    },
    // remove info window, reset highlight
    mouseout: function(e){
      info.update();
      resetHighlightState(e);
    }
  })
}
{% endhighlight %}

## Doing More From this Point

There are a lot of things you can do from this starting point.  By hooking into click methods we could do something interesting like loading county data or we could load other datasets by utilizing a drop down.

If you'd be interested in learning more about using visualizations to make data more accessible, feel free to drop me a line!
