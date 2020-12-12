defmodule Servy.Bear do
	defstruct name: "", id: nil, type: "", hibernating: false 

	def is_grizzly(bear) do
		bear.type == "Grizzly"
	end

	def sort_by_name(b1, b2) do
		b1.name <= b2.name
	end
end