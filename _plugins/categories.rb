module Jekyll
  module CategoryFilter
    def dashed_category_name(cat)
      cat.gsub(/\s+/, '-')
    end
  end
 
  Page.class_eval {
  
    def clone
      Page.new(@site, @base, @dir, @name)
    end
 
  }
 
  class CategoryPageGenerator < Generator
    safe true
    priority :high
 
    def generate(site)
      puts "Generating categories"
      main_cat_page = site.pages.select { |p| p.name == "category.html" }.first
 
      site.categories.each do |cat|
        cat_page = main_cat_page.clone
        cat_name_orig = cat.first
        cat_name = cat.first.gsub(/\s+/, '-')
        
 
         cat_page.data.merge!(
           "title" => "Category: #{cat_name_orig}",
           "permalink" => "/category/#{cat_name}/",
           "category_name" => cat_name_orig,
           )
         cat_page.render(site.layouts, site.site_payload)
 
         site.pages << cat_page
      end
 
    end
  end
end

Liquid::Template.register_filter(Jekyll::CategoryFilter)