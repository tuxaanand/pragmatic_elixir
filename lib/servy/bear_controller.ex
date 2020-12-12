defmodule Servy.BearController do
	
	alias Servy.Bear
	alias Servy.Wildthings

	defp render_bear(bear) do
		"<li>#{bear.name}</li>"
	end

	def index(conv) do
		bears = Wildthings.list_bears()
				|> Enum.filter(&Bear.is_grizzly/1)
				|> Enum.sort(&Bear.sort_by_name/2)
				|> Enum.map(&render_bear/1)
				|> Enum.join
		%{conv | status: 200, resp_body: "<ul>#{bears}</ul>"}
	end

	def show(conv, %{"id" => id}) do
		bear = Wildthings.get_bear(id)
		%{conv | status: 200, resp_body: "Bear ID - #{bear.id}, Bear Name - #{bear.name}"}
	end

	def create(conv, %{"name" => name, "type" => type}) do
		%{conv | status: 201, resp_body: "Created a #{type} bear named #{name}"}
	end

	def delete(conv, _params) do
		%{conv | status: 403, resp_body: "Deleting a bear is forbidden"}
	end

end