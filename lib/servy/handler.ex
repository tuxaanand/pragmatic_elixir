
defmodule Servy.Handler do
	@moduledoc """
	A HTTP Request handler.
	"""

	import Servy.Plugins, only: [rewrite_path: 1, log: 1, log: 2]
	import Servy.Parser, only: [parse: 1]
	import Servy.FileHandler, only: [handle_file: 2]
	
	alias Servy.Conv

	@pages_path Path.expand("pages", File.cwd!)

	@doc """
	The entry point function that transforms the request
	into a response
	"""
	def handle(request) do
		request 
			|> parse
			|> rewrite_path
			|> log
			|> route
			|> format_response
	end


	# def route(conv) do
	# 	route(conv, conv.method, conv.path)
	# end

	def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
		%{conv | status: 200, resp_body: "Bears, Tiger, Lion"}
	end

	def route(%Conv{method: "GET", path: "/bears"} = conv) do
		%{conv | status: 200, resp_body: "Teddy, Smokey, Padington"}
	end

	def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
		%{conv | status: 200, resp_body: "Bear ID - #{id}"}
	end

	def route(%Conv{method: "POST", path: "/bears"} = conv) do
		%{conv | status: 201, resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}"}
	end

	def route(%Conv{method: "GET", path: "/pages/" <> file_name} = conv) do
		@pages_path
		|> Path.join(file_name <> ".html")
		|> log("File")
		|> File.read
		|> handle_file(conv)
	end

	def route(%Conv{} = conv) do
		%{conv | status: 404, resp_body: "No #{conv.path} here"}
	end

	def format_response(%Conv{} = conv) do
		"""
		HTTP/1.1 #{Conv.full_status(conv)}
		Content-Type: text/html
		Content-Length: #{String.length(conv.resp_body)}

		#{conv.resp_body}
		"""
	end

	
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)


request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)


request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)


request = """
GET /pages/about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)


request = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
IO.puts Servy.Handler.handle(request)


request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts response
