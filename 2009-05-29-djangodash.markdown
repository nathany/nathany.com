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

Today, May 29th, at 10:00 PM PDT begins the [Django Dash][djangodash] programming competition. Having not used Django or Python significantly since 2006, I intend to use it as a learning experience.

### port 43

My [project][] is to build a **whois** web application using the Python socket library. Shelling to a command line `whois` would pick the right server and do the recursive thing when necessary, but I want to try writing it by hand.

Whois servers reply in irregular fashion, information which will need to be translated into a standard format to be useful.

To this, a fairly simple Django front-end can request a domain name and present nicely styled results.

### extra polish

If I have time, I may add a simple "human check" (not a CAPTCHA) and some per-user throttling to keep the whois requests down.

Finally, I must take care to remember Unicode domain names, socket errors/timeouts, and security (sanitizing input).

### source code

While I may not make a live example available, I intend to open source my work once the competition finishes, most likely placing it on [Google Code][googlecode].


*You can follow my progress on [Twitter][], and I will update this post once the competition is over.*



[Twitter]: http://twitter.com/nathany

[djangodash]: http://alt.djangodash.com/
[project]: http://alt.djangodash.com/teams/57/
[awis]: http://aws.amazon.com/awis/

[googlecode]: http://google-code-updates.blogspot.com/2009/05/mercurial-now-available-to-all-open.html
