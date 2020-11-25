require Logger

defmodule Servy.Handler do

	@http_codes %{
			200 => "OK",
			404 => "Not Found",
			403 => "Forbidden",
			405 => "Method Not Allowed",
			500 => "Internal Server Error"
	}

	def handle(request) do
		request 
			|> parse
			|> rewrite_path
			|> log
			|> route
			|> format_response
	end

	def log(conv) do
	 Logger.info conv
	 conv
	end

	def parse(request) do
		[method, path, _version] 
				= request 
						|> String.split("\n")
						|> List.first()
						|> String.split(" ")

		%{method: method, path: path, status: nil, resp_body: ""}
	end

	def rewrite_path(%{path: "/wildlife"} = conv) do
		%{conv | path: "/wildthings"}
	end

	def rewrite_path(conv), do: conv

	# def route(conv) do
	# 	route(conv, conv.method, conv.path)
	# end

	def route(%{method: "GET", path: "/wildthings"} = conv) do
		%{conv | status: 200, resp_body: "Bears, Tiger, Lion"}
	end

	def route(%{method: "GET", path: "/bears"} = conv) do
		%{conv | status: 200, resp_body: "Teddy, Smokey, Padington"}
	end

	def route(%{method: "GET", path: "/bears/" <> id} = conv) do
		%{conv | status: 200, resp_body: "Bear ID - #{id}"}
	end

	def route(conv) do
		%{conv | status: 404, resp_body: "No #{conv.path} here"}
	end

	def format_response(conv) do
		"""
		HTTP/1.1 #{conv.status} #{status_text(conv.status)}
		Content-Type: text/html
		Content-Length: #{String.length(conv.resp_body)}

		#{conv.resp_body}
		"""
	end

	defp status_text(code) do
		@http_codes[code]
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
