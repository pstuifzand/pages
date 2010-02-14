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
begin 
  require 'rubygems'
  require_gem 'BlueCloth'
rescue
  require 'bluecloth'
end
require 'date'
require 'pages/storage/month'
require 'cgi'

module Pages
module Storage

class Entry 
  attr_accessor :title, :tags, :date, :content, :is_html, :draft, :html_file

  def initialize(weblog)
    @weblog = weblog
  end

  def changed_since(time)
    return @weblog.changed_since(time, self)
  end

  def filename 
    @date.strftime("%Y%m%d%H%M%S") + ".tp"
  end

  def outfile
#    return @date.strftime("%Y%m%d%H%M%S") + ".html"
    if html_file
      return html_file
    end
    f = title.dup
    f.gsub!(/[ #,:.!!\[\]?']+/, '-')
    f.sub!(/^-/, '')
    f.sub!(/-$/, '')
    f.downcase!
    return f + ".html"
  end

  def outdir 
    return @date.strftime("%Y/%m/%d")
  end


  def to_html
    return is_html ? @content : BlueCloth.new(@content).to_html
  end

  def summary 
    return to_html
  end

  def permfile
    return outdir + '/' + (html_file || outfile)
    #return html_file || outfile
  end

  # FIXME: move
  def title_header
    return <<"HTML"
    <span style="color:#777;font-style:italic;margin-bottom:0">#{@date.strftime('%c')}</span>
<h2 class='title'><a class='title' href='/#{permfile}'>#{title}</a></h2>
HTML
  end

  # FIXME: move
  def title_footer
    return <<"HTML"
<div class='footer'>
<table width='100%'><tr>
<td><span class='date'><a href="/#{permfile}" class="permalink">#{format_date(@date)}</a></span></td>
<td align='right'><span class='tags'>#{@tags.collect{|x| "<a href='/tag/#{x}' rel='tag'>#{x}</a>"}.join(", ")}</span></td>
</tr></table></div>
HTML
  end

  def archive_page
    return date.strftime("%Y/%m")
  end

  def posted_on
    return date.strftime("%B ") + date.day.to_s + date.strftime(", %Y")
  end

  def permalink_id
    return @date.strftime("%Y%m%d%H%M%S")
  end

  def permalink_text
    return date.strftime("%H:%M")
  end

  def prev_month
    prev = Date.civil(date.year, date.month, date.day) << 1

    while !@weblog.month_with_entries(prev) && prev.year >= 2004
      prev = prev << 1
    end

    return Pages::Storage::Month.new(prev.year >= 2004, prev, false)
  end

  def next_month
    nextd = Date.civil(date.year, date.month, 1) >> 1

    while !@weblog.month_with_entries(nextd) && nextd <= Date.today
      nextd = nextd >> 1
    end

    return Pages::Storage::Month.new(nextd <= Date.today, nextd, true)
  end

  def comments
    str = '<h3>Comments</h3>'

    dir = File.join(@weblog.comment_dir, permalink_id)
    
    return str + "<p>No comments</p>" if !File.exist?(dir)
    Dir.open(dir) do |d|
      comments = d.reject{|f| f == '.' or f == '..' }.sort
      str += "<table>"
      comments.each do |file|
        comment = YAML.load_file(File.join(dir, file))
        str += "<tr><td>On " + comment['time'].strftime("%Y-%m-%d %H:%M:%S") + ' ' + comment['username'] + " wrote</td></tr>"
        str += "<tr><td>" + CGI.escapeHTML(comment['comment']) + "</td></tr>"
        str += "</tr>"
      end
      str += "</table>"
    end

    return str
  end

  def comment_count

    dir = File.join(@weblog.comment_dir, permalink_id)

    return 0 if !File.exist?(dir)

    count = 0

    Dir.open(dir) do |d|
      comments = d.reject{|f| f == '.' or f == '..' }.sort
      return comments.size
    end
    return 0
  end

end

end
end

