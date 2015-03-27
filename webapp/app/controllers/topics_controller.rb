class TopicsController < ApplicationController
	
	def create
		@topic = Topic.new(params[:topic])
		if @topic.save
			redirect_to 'index'
		else
			render json: {:error => "Failed to create topic"}
		end
	end

	# Uses a custom SQL query to get the topic and all of its
	# children.
	# TODO fix the route for this action so that the param
	# isn't misleadingly called 'id' when it's actualy the topic name
	def show
		# render json: Topic.find_by_name(params[:id])
		render json: Topic.get_tree(params[:id]), each_serializer: TopicHierarchySerializer
	end

	def index
		# If a query string was provided, return all the topics 
		# whose names contain the query string and all of their
		# prereqs.
		if params['name'] != nil
			render json: Topic.get_subgraph(params['name']), each_serializer: TopicPrereqGraphSerializer

		# Use this endpoint without any name parameter as a
		# means of getting a JSON dump of all topics in development,
		# but return nothing in production.
		elsif Rails.env == "development"
			render json: Topic.all, each_serializer: TopicPrereqGraphSerializer
		else
			render json: Topic.none
		end
	end

end
