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
require 'pages/template'
require 'fileutils'

module Pages
module Blog
class Page < Pages::GeneratePage
  def initialize(website, srcdir, outdir)
    super(website, srcdir, outdir)
    @srcdir=srcdir
  end

  def header(page, title=nil)
    open_file(outfile(page))
    actual_title = page.title
    show_header(@out, actual_title)
    @out.puts @tp.post_header.to_str(@website.template_vars({ 'page_title' => title_with_website_at_end(actual_title),  'title' => actual_title, 'menu' => @website.menu_html }))
    @out.puts page_title_header(page)
  end

  def footer(page, title=nil)
    actual_title = page.title
    @out.puts page_title_footer(page)
    @out.puts @tp.post_footer.to_str(@website.template_vars({ 'page_title' => title_with_website_at_end(actual_title), 'title' => actual_title, 'menu' => @website.menu_html }))
    show_footer(@out)
  end

  def outfile(page)
    dir = @outdir + '/' + page.outdir
    if (!File.exists?(dir))
      FileUtils.mkdir_p(dir)
    end

    file = @outdir + '/' + page.outdir + '/' + page.outfile
    return file
  end

  # FIXME move?
  def page_title_header(page)

    template = Pages::Template.new(@srcdir + '/entry-header.tpf')
    if template.exists?
      return template.to_str({ 'posted_on' => page.posted_on })
    else
      return <<"HTML"
<span class="date">#{page.posted_on}</span>
HTML
    end
  end

  # FIXME move?
  def page_title_footer(page)
    template = Pages::Template.new(@srcdir + '/entry-footer.tpf')
    if template.exists?
      return template.to_str({ 'posted_on' => page.posted_on, 'comments' => page.comments, 'permalink' => page.permalink_id,
                  'permalink_text' => page.permalink_text, 'url' => page.permfile,
                  'tags' => page.tags.collect{|x| "<a href='/tag/#{x}' rel='tag'>#{x}</a>"}.join(", ") })
    else
      return <<"HTML"
<div class='footer'>
<table width='100%'><tr><td><span class='date'>
<a href="/#{page.permfile}" class="permalink">#{page.permalink_text}</a></span></td>
<td align='right'><span class='tags'>#{page.tags.collect{|x| "<a href='/tag/#{x}'>#{x}</a>"}.join(", ")}</span></td></tr>
</table></div>
HTML
    end
  end
end
end
end
