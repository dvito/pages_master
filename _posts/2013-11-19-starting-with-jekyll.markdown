---
layout: post
title:  "Starting with Jekyll"
date:   2013-11-19 19:45:00
categories: jekyll ruby
---

I'm testing Jekyll right now as a blogging / resume site method. This test post contains some code syntax highlighting

ruby
{% highlight ruby linenos table %}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}

bash
{% highlight bash %}
jekyll build --destination ../dvito.github.io --watch

jekyll build serve --watch
{% endhighlight %}