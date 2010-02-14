# Copyright 2007 Peter Stuifzand
# This file is part of Pages.
#
# Pages is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Pages is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Pages.  If not, see <http://www.gnu.org/licenses/>.
require 'cgi'

module Pages
module Blog
class HTMLFeed
  def initialize(website,srcdir, outdir)
    @website = website

    @outfile = File.new(outdir +'/feed.html', 'w')
    @outfile.sync=true

    @count = 0
    @numitems = 10
  end

  def header
    @outfile.print <<"HEAD"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <title>#{@website.title}</title>
  <link rel="alternate" href="/index.html" title="Normal browser version" type="text/html" />
</head>

<body>
    <h1>#{@website.title}</h1>
    <p><a href="#{@website.baseurl}">Homepage</a></p>
HEAD
  end

  def footer
    @outfile.puts "</body></html>"
    @outfile.close
  end

  def item(page)
    @outfile.print <<"ITEM"
<div class="entry">
  <h2>#{page.title}</h2>
  <div class="content">#{page.to_html}</div>
  <a href="#{@website.baseurl}/#{page.permfile}">permalink</a>
  <span class="date">#{page.date.strftime('%a, %d %b %Y %H:%M:00 +0100')}</span>
</div>
ITEM
    @outfile.flush
    
    @count += 1
    return @numitems == -1 || @count < @numitems
  end
end
end
end

