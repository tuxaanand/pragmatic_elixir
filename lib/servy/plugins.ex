require Logger


defmodule Servy.Plugins do

	alias Servy.Conv
	
	def log(conv, message \\ "") do
		case message do
			"" -> Logger.info conv
			_ -> Logger.info [message: message, value: conv]
				
		end
	 conv
	end

	def rewrite_path(%Conv{path: "/wildlife"} = conv) do
		%{conv | path: "/wildthings"}
	end

	def rewrite_path(%Conv{path: "/bears/new"} = conv) do
		%{conv | path: "/pages/bears/form"}
	end

	def rewrite_path(%Conv{} = conv), do: conv

end
