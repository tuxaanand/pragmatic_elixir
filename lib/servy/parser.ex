
defmodule Servy.Parser do

	alias Servy.Conv

	def parse(request) do
		[top, params_string] = String.split(request, "\n\n")
		[request_line | header_lines] = String.split(top, "\n")
		[method, path, _version] = String.split(request_line, " ")

		%Conv{method: method, path: path, params: parse_params(params_string)}
	end

	defp parse_params(params_string) do
		params_string 
			|> String.trim 
			|> URI.decode_query
	end
end