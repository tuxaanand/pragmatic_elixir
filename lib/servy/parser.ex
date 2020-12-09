
defmodule Servy.Parser do

	alias Servy.Conv

	def parse(request) do
		[top, params_string] = String.split(request, "\n\n")
		[request_line | header_lines] = String.split(top, "\n")
		[method, path, _version] = String.split(request_line, " ")

		headers = parse_headers(header_lines, %{})

		%Conv{method: method, 
			path: path, 
			params: parse_params(headers["Content-Type"], params_string), 
			headers: headers}
	end

	defp parse_headers([head | tail], %{} = headers) do
		[key, value] = head 
						|> String.split(":")
						|> Enum.map(fn v -> String.trim(v) end)
		
		parse_headers(tail, Map.put(headers, key, value))
	end

	defp parse_headers([], %{} = headers), do: headers

	defp parse_params("application/x-www-form-urlencoded", params_string) do
		params_string 
			|> String.trim 
			|> URI.decode_query
	end

	defp parse_params(_, _), do: %{}
		
end