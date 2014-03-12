---
layout: post
title:  "Starting with Jekyll"
date:   2014-03-10 15:45:00
categories: jekyll ruby
---

I'm testing Jekyll right now as a blogging / resume site method.  Its a pretty cool application, and really frees me up to just write some simple markdown, without getting caught up in a ton of other development issues.

I'm using two repositories to accomplish my Jekyll goals, due to the lack of plugin support when using [<i class="fa fa-github-alt">Github</i>](https://github.com/) as a host.

From ../pages_master
{% highlight bash %}
jekyll build --destination ../dvito.github.io --watch
{% endhighlight %}

In ../dvito.github.io
{% highlight bash %}
jekyll serve --watch
{% endhighlight %}

You can also configure this in ../_config.yml
{% highlight bash %}
source: /Users/justinraines/Code/pages_master
destination: /Users/justinraines/Code/dvito.github.io
{% endhighlight %}

And then you can just run:
From ../pages_master
{% highlight bash %}
jekyll build --watch
{% endhighlight %}
In ../dvito.github.io
{% highlight bash %}
jekyll serve --watch
{% endhighlight %}