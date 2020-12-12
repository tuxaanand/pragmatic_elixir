defmodule Servy.BearController do
	
	alias Servy.Bear

	def index(conv) do
		%{conv | status: 200, resp_body: "Teddy, Smokey, Padington"}
	end

	def show(conv, id) do
		%{conv | status: 200, resp_body: "Bear ID - #{id}"}
	end

	def create(conv, %{"name" => name, "type" => type}) do
		%{conv | status: 201, resp_body: "Created a #{type} bear named #{name}"}
	end

end