class Post < ActiveRecord::Base
	validates :longurl, :format => URI::regexp(%w(http https))
	validates :longurl, presence: true,
	length: { minimum: 5 }
end