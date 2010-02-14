# Copyright 2004-2008 Peter Stuifzand
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

require 'yaml'
require 'pages/storage/entry'

module Pages
class BlogModel
  def initialize(srcdir, indexfile)
    @srcdir = srcdir
    @indexfile = indexfile
    @items = []

    load_index
  end

  def file_in_blog(name)
    return File.join(@srcdir, 'blog', name)
  end

  def changed_since(time, entry)
    return true
    return true if time < File.mtime(file_in_blog(entry.filename)) || time < File.mtime(file_in_blog('index.yaml'))
  end

  def month_with_entries(time)
    return @entry_in_month.has_key?(time.strftime('%Y%m'))
  end

  def load_index
    @entry_in_month = {}

    File.open(index_filename, 'r') do |f|
      YAML::load_documents(f) do |item|
        entry = Pages::Storage::Entry.new(self)
        entry.title = item['title']
        entry.tags = item['tags']
        entry.date = item['date']
        entry.is_html = item['is_html']
        entry.draft = item['draft'] || false
        entry.html_file = item['html_file']

        @entry_in_month[entry.archive_page] = true

        File.open(@srcdir + '/blog/' + item['filename']) do |infile|
          entry.content = infile.read
        end
        
        @items << entry
      end
    end

    @items = @items.sort_by{|item| item.date}.reverse
  end

  # returns a new item, it is not saved.
  def newitem
    entry = Pages::Storage::Entry.new(self)

    entry.title = ''
    entry.tags = []
    entry.date = Time.new
    entry.content = ''
    entry.draft = false

    @items << entry

    return entry
  end

  def pages
    return @items.sort_by{|p| p.date}.reverse
  end

  def index_filename
    return @srcdir + '/blog/' + @indexfile
  end

  def comment_dir
    return File.join(@srcdir, 'blog', 'comments')
  end

  def saveall
    puts "saving the blogmodel"

    File.open(index_filename, 'w') do |f|
      @items.each do |item|

        File.open(@srcdir + '/blog/' + item.filename, 'w') do |content|
          content.print item.content
        end

        href = { 
          'title'     => item.title,
          'tags'      => item.tags,
          'date'      => item.date,
          'filename'  => item.filename,
          'is_html'   => item.is_html,
          'draft'     => item.draft,
          'html_file' => item.outfile,
        }
        f.puts(href.to_yaml)
      end
    end

    puts "done"
  end
end

end
