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
require 'pages/blog/page'

module Pages
module Blog
class Item
  def initialize(website, srcdir, outdir)
    @outdir=outdir
    @blogpagegen=Pages::Blog::Page.new(website, srcdir, outdir)
  end

  def header ; end

  def footer ; end

  def item(page)
    @blogpagegen.generate(page)
    return true
  end
end

end
end
