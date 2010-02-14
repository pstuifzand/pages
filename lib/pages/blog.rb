# Copyright 2004 Peter Stuifzand
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

require 'pages/storage/blog'

require 'pages/blog/rss20'
require 'pages/blog/page'
require 'pages/blog/list'
require 'pages/blog/archive'
require 'pages/blog/item'
require 'pages/blog/monthly'
require 'pages/blog/htmlfeed'

module Pages
module Blog
class Generate
  def initialize(website, srcdir, outdir, config)
    @srcdir = srcdir
    @outdir = outdir
    @config = config

    Dir.mkdir(@outdir) unless File.exist?(@outdir)

    @generators = [
      Pages::Blog::Item.new(website, srcdir, @outdir),
      Pages::Blog::Monthly.new(website, srcdir, @outdir, 'archive.html', @config),
      Pages::Blog::List.new(website, srcdir, @outdir, @config['blog_file'] || 'index.html', { 'css_file' => @config['css_file'], 'numitems' => 10, 'comments_on' => @config['comments_on'], 'byline' => @config['byline']}),
      Pages::Blog::RSS20.new(website, srcdir, @outdir, config),
      Pages::Blog::Archive.new(website, srcdir, @outdir),
      Pages::Blog::HTMLFeed.new(website, srcdir, @outdir),
    ]

    @blogmodel = Pages::BlogModel.new(srcdir, 'index.yaml')
  end

  def generate
    @generators.each{|gen| gen.header }

    gens = @generators

    @blogmodel.pages.each do |page|
      if !page.draft
        gens = gens.select{ |gen| gen.item(page) }
      end
    end

    @generators.each{|gen| gen.footer }
  end
end
end
end
