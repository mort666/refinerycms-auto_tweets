class BlogPostObserver < ActiveRecord::Observer
	observe Refinery::Blog::Post
	
	def after_save(record)
    if record.should_tweet?
      record.post_tweet!
    end
  end
end