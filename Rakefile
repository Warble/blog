require 'rake/clean'
CLOBBER.include('_site')

GH_PAGES = "../warble-gh-pages"
HOST = "git@github.com:Warble/blog.git"

directory GH_PAGES

task :default => ["publish"]

desc "Publishes the site to the gh-pages branch"
task :publish => [ GH_PAGES, :clobber ] do
  source_dir = Dir.pwd
  jekyll = `jekyll`
  if not jekyll =~ /Successfully generated site/
    abort("Site not successfully generated - exiting")
  end
  puts jekyll
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
  #unless commit =~ /nothing to commit/
    # push
    puts `git push origin gh-pages --force`
  #end
end