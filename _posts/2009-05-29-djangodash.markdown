Type: Blog Post (Markdown)
Blog: nathany
Link: http://nathany.com/developer/djangodash/
Post: 253
Title: Django Dash
Slug: djangodash
Keywords: competition, django, whois
Status: publish
Date: 2009-05-29 00:28:05 -0700
Pings: On
Comments: On
Category: developer

On May 29th, at 10:00 PM PDT began the [Django Dash][djangodash] 48-hour programming competition. Having not used Django or Python significantly since 2006, I signed up to use it as a learning experience.

### port 43

My [project][] is to build a **whois** web application using the Python socket library. Shelling to a command line `whois` would pick the right server and do the recursive thing when necessary, but I want to try writing it by hand.

This part was actually pretty easy.

### parsing

Whois responses are incredibly inconsistent, and as such, trying to parse them into a standard format has been a real challenge. My current approach is to chunk it in a generic way based on *Labels:* that generally end in a colon.

To do this, I've used Python's regular expression library, which works extremely well. I took to the verbose mode to add comments, and even utilized some look-ahead.

I considered using [pyparsing][] with indentedBlock and even glanced at the source of [PyYAML][], but I decided not too learn or add a bunch of third-party code for the competition. 

Another alternative might be to use a differencing based scraping tool. Adrian Holovaty did a talk on EveryBlock where they used such a tool to find the article in web pages by ignoring the stuff that doesn't change between articles. If I gathered enough sample data for each whois server, I might be able to form a sort of template of what never changes. The important information is what changes, and *Labels:* could be extracted from the static text even when no colon exists.

That may be a better long-term solution, but I'm going to leave parsing for now to work on the rest of the system.


### using Django

So far Django 1.0.2 has held up well, creating a <strike>new</strike>forms class with custom validation is pretty slick, and the built in test-runner is handy.  

In terms of out-of-the-gate code generation, it took quantifiably longer than with Rails. For example, I wrote this doozy to get the development server to serve static files from my `public/` folder (`MEDIA_ROOT`), which *just works* in Rails:

<pre lang="python">
# serve static pages on development server (urls.py)
if 'runserver' in sys.argv:
    urlpatterns += patterns('',
        (r'^(?P<path>(?:images|styles|scripts)/.*)$',
            'django.views.static.serve', 
            {'document_root': settings.MEDIA_ROOT}),
    )  
</pre>

### using Python

Python is great.

When I was looking into supporting Unicode characters in domains, such as used by [tinyarro.ws][], I found built-in support for IRDA and Punycode encodings.

My only rant is that I'm impatient to be using Python 3.x. At this point it makes little sense to write any significant amount of 2.x code, but it's either wait for the frameworks/platforms, or blaze a new frontier from scratch.

[tinyarro.ws]: http://tinyarro.ws/
[PyYAML]: http://pyyaml.org/
[pyparsing]: http://pyparsing.wikispaces.com/
[idna]: http://en.wikipedia.org/wiki/Internationalized_domain_name

[Twitter]: http://twitter.com/nathany

[djangodash]: http://alt.djangodash.com/
[project]: http://alt.djangodash.com/teams/57/
[awis]: http://aws.amazon.com/awis/

[googlecode]: http://google-code-updates.blogspot.com/2009/05/mercurial-now-available-to-all-open.html


*[IRDA]: Internationalizing Domain Names in Applications
