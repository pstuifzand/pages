# Copyright 2005 Peter Stuifzand
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

require 'pages/storage/website'
require 'pages/page'
require 'pages/generate/sitemap'

module Pages

class GeneratePages
  def initialize(website, srcdir, outdir)
    @website = website
    @srcdir = srcdir
    @outdir = outdir

    @pagegen = Pages::GeneratePage.new(@website, @srcdir, @outdir)
    @sitemap = Pages::Generate::Sitemap.new(@website, @srcdir, @outdir)
  end

  def generate
    @website.pages.each do |page|
      @pagegen.generate(page)
    end

    @sitemap.generate
  end
end

end

