---
layout: page
title: Writing
permalink: /blog/
---

{: .lede }
Notes on measurement, hardware, and systems that have to keep running.
[Subscribe by RSS]({{ '/feed.xml' | relative_url }}).

<ul class="post-list">
{%- for post in site.posts %}
  <li>
    <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %-d, %Y" }}</time>
    <h2><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2>
    {%- if post.description or post.excerpt %}
    <p>{{ post.description | default: post.excerpt | strip_html | truncate: 180 }}</p>
    {%- endif %}
  </li>
{%- else %}
  <li><p>Nothing published yet.</p></li>
{%- endfor %}
</ul>
