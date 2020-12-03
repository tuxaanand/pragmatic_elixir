require Logger

defmodule Servy.Plugins do
	
	def log(conv, message \\ "") do
		case message do
			"" -> Logger.info conv
			_ -> Logger.info [message: message, value: conv]
				
		end
	 conv
	end

	def rewrite_path(%{path: "/wildlife"} = conv) do
		%{conv | path: "/wildthings"}
	end

	def rewrite_path(%{path: "/bears/new"} = conv) do
		%{conv | path: "/pages/bears/form"}
	end

	def rewrite_path(conv), do: conv

end
