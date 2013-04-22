# encoding: UTF-8
require 'nokogiri'

require 'rake/clean'
CLOBBER.include('_site')

GH_PAGES = "../warble-gh-pages"
HOST = "git@github.com:Warble/blog.git"

directory GH_PAGES

task :default => ["publish"]

task :build do
  jekyll = `jekyll`
  if not jekyll =~ /Successfully generated site/
    abort("Site not successfully generated - exiting")
  end
  puts jekyll
end

desc "Publishes the site to the gh-pages branch"
task :publish => [ GH_PAGES, :clobber, :build, :quotes ] do
  source_dir = Dir.pwd
  # remove unwanted files
  File.delete("_site/category.html")
  # get our last log entry
  last_log = `git log --no-decorate --pretty=oneline --abbrev-commit -n1`
  puts last_log
  # change to dest dir and store
  Dir.chdir GH_PAGES
  dest_dir = Dir.pwd
  # clone if not already cloned
  clone = `git clone -b gh-pages #{HOST} .`
  # sync changes
  puts `rsync -rtvuc --delete --exclude '.git' #{source_dir}/_site/ ~/warble-gh-pages`
  # git add changes
  puts `git add . -u`
  puts `git add .`
  # commit
  commit = `git commit -m "Publish: #{last_log}"`
  puts commit
  puts `git push origin gh-pages --force`
end

desc "Replace dumb quotes with smart quotes"
task :quotes do
  html_files = File.join("_site", "**", "*.html")
  Dir.glob html_files do |html_file|
    puts "Dumb quotes: #{html_file}"

    file = File.open(html_file)
    contents = file.read

    doc = Nokogiri::XML(contents)

    tags = ['p', 'a', 'h1', 'h2', 'h3', 'span']
    tags.each do |tag|
      for elem in doc.xpath("//#{tag}/text()")
        elem.content = elem.content.gsub(/'/, '’') # apostrophe
        elem.content = elem.content.gsub(/"(.*?)"/, '“\\1”') #nice quotes
      end
    end

    #Potentially destructive.
    file = File.new(html_file,"w")
    file.write(doc)
    file.close
  end
end