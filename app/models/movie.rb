class Movie < ActiveRecord::Base
    def self.all_ratings
        #@all_ratings = ['G','PG','PG-13','R']
        @all_ratings = Movie.uniq.pluck(:rating)
    end
    
    def self.with_ratings (ratings)
        where("rating IN (?)",ratings)
    end
end
