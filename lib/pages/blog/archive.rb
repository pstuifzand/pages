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
require 'pages/blog/list'

module Pages
module Blog
class Archive
  def initialize(website, srcdir, outdir)
    @website = website
    @srcdir=srcdir
    @outdir=outdir
  end

  def header
    @generators = Hash.new(nil)
    Dir.mkdir("#{@outdir}/tag") if !File.exist?("#{@outdir}/tag")
  end

  def footer
    @generators.each{|key, val| val.footer}
  end

  def item(page)
    page.tags.each do |tag|
      if @generators[tag] == nil
        @generators[tag] = Blog::List.new(@website, @srcdir, @outdir, "/tag/#{tag}.html")
        @generators[tag].header("Weblog: #{tag}")
      end
      @generators[tag].item(page)
    end
  end
end

end
end

