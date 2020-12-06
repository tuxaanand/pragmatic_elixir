
defmodule Servy.Conv do

	alias Servy.Conv

	@http_codes %{
			200 => "OK",
			404 => "Not Found",
			403 => "Forbidden",
			405 => "Method Not Allowed",
			500 => "Internal Server Error"
	}

	defstruct [
		method: "", 
		path: "", 
		params: %{},
		status: nil, 
		resp_body: ""	
	]

	def full_status(%Conv{} = conv) do
		"#{conv.status} #{status_text(conv.status)}"
	end

	defp status_text(code) do
		@http_codes[code]
	end
end
