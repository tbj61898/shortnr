require 'digest/sha1'

class PostsController < ApplicationController
	layout "application"
	def initialize
		@key1 = "S6hMI1vC5xREHYzUaZPotJgQi84ONXpc2GVFKkWb3syDLlrwej97dmTnBAufq0"
		@key2 = "oVCW97TA5S8fIN1LcBYwMUat0ZgRyx3ilkJE4musOpHzjnqhrFK6XDebPQGd2v"
		@key3 = "PMbGsEKu8IjAyJpx3WdDnvk0mFNStialgcqR9Q74oYhXLr21CzTO6VHfwBeU5Z"
		@key4 = "zMGqLQKpmYnaJcbTgdyf3u64WA59UNRtVkEBPv1xel7iI0C8sHoOZjSrhwXFD2"
		@key5 = "a9SxgDRPCVtebFclvzBmNdLwrn0GAO8jKU63fEI25q41uYpiZy7hoMWXkJQTsH"
		@key6 = "sVLuIcQRW1gAf8bJk5dvB6HaxyqTPZG2DX9KSOejtr03ilw47mUCMFoENnzpYh"
		@base = 36
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		if !(@post.longurl.start_with?("http://") | @post.longurl.start_with?("https://")) 
			@post.longurl = "http://#{@post.longurl}"
		end
		if @post.save
			@post.shorturl=shortit(@post.id)
			@post.save
			redirect_to @post
		else
			render 'edit'
		end
	end

	def show
  		@post = Post.find(params[:id])
	end
	
	def open
  		@post = longit(params[:id])
  		@post.visited = @post.visited + 1
  		@post.save
  		redirect_to @post.longurl
	end

	def index
		@post = Post.new
  		@posts = Post.all(:order => "created_at DESC", :limit => 15)
  		@opposts = Post.all(:order => "visited DESC", :limit => 15)
	end

	def destroy
	 	@post = Post.find(params[:id])
  		@post.destroy
  		redirect_to posts_path
	end

	private
		def post_params
			params.require(:post).permit(:longurl)
		end

		def shortit(aId)
			anId = "%06s" % [aId.to_i.to_s(@base)]
			anId = anId.gsub(" ","0")
			val1 = anId.byteslice(0,1).to_i(@base)
			logger.debug "shortit: #{anId.to_s} is #{val1.to_s}"
			val2 = anId.byteslice(1,1).to_i(@base)
			val3 = anId.byteslice(2,1).to_i(@base)
			val4 = anId.byteslice(3,1).to_i(@base)
			val5 = anId.byteslice(4,1).to_i(@base)
			val6 = anId.byteslice(5,1).to_i(@base)
			res1 = @key1.byteslice(val1,1)
			res2 = @key2.byteslice(val2,1)
			res3 = @key3.byteslice(val3,1)
			res4 = @key4.byteslice(val4,1)
			res5 = @key5.byteslice(val5,1)
			res6 = @key6.byteslice(val6,1)
			result = res1 + res2 + res3 + res4 + res5 + res6
			return result
		end

		def longit(aId)
			anId = "%06s" % [aId]
			anId = anId.gsub(" ","0")
			val1 = anId.byteslice(0,1)
			val2 = anId.byteslice(1,1)
			val3 = anId.byteslice(2,1)
			val4 = anId.byteslice(3,1)
			val5 = anId.byteslice(4,1)
			val6 = anId.byteslice(5,1)
			res1 = @key1.rindex(val1)
			logger.debug " #{val1.to_s} is #{res1.to_s}"
			res2 = @key2.rindex(val2)
			res3 = @key3.rindex(val3)
			res4 = @key4.rindex(val4)
			res5 = @key5.rindex(val5)
			res6 = @key6.rindex(val6)
			logger.debug " #{val6.to_s} is #{res6.to_s}"
			aId = res1.to_s + res2.to_s + res3.to_s + res4.to_s + res5.to_s + res6.to_s
			@post = Post.find(aId.to_i)
			return @post
		end

end
