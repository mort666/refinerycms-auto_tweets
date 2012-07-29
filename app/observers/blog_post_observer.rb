class BlogPostObserver < ActiveRecord::Observer
	observe :refinery_blog_post
	def after_save(record)
    if record.should_tweet?
      record.post_tweet!
    end
  end
end