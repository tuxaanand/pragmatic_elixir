defmodule Servy.Handler do
	def handle(request) do
		request 
			|> parse
			|> route
			|> format_response
	end

	def parse(request) do
		[method, path, version] 
				= request 
						|> String.split("\n")
						|> List.first()
						|> String.split(" ")

		%{method: method, path: path, resp_body: ""}
	end

	def route(conv) do
		conv = %{conv | resp_body: "Bears, Tiger, Lion"}
	end

	def format_response(conv) do
		conv.resp_body
	end
end

IO.puts Servy.Handler.handle("GET /wildthings HTTP/1.1")
