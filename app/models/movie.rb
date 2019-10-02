class Movie < ActiveRecord::Base
    def self.all_ratings
        #@all_ratings = ['G','PG','PG-13','R']
        @all_ratings = Movie.uniq.pluck(:rating)
    end
    
    def self.with_ratings (ratings)
        #joins(:ratings).where("ratings.rating == ?", all_ratings)
        where("rating")
        
        #where(!(all_ratings & ratings).empty?)
        #where(ratings.include? all_ratings)
    end
end
