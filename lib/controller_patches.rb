# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    GeneralController.class_eval do
            # Make sure it doesn't break if blog is not available
        def frontpage
            begin
                blog
            rescue
                puts "ERROR"
                @blog_items = []
                @twitter_user = MySociety::Config.get('TWITTER_USERNAME', '')
            end

            begin
                @featured_requests = InfoRequest.find( :all,
                                                        :conditions => ["prominence='normal'"],
                                                        :order => "updated_at desc",
                                                        :limit => 3)
            rescue
                @featured_requests = []
            end
        end
    end
end
