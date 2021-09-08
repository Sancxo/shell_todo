defmodule ShellTodo do
    def start() do
        filename = IO.gets("Name of the file.csv to load: ") |> String.trim()
        read(filename)
    end

    def read(filename) do
        case File.read(filename) do
            {:ok, body} ->
                body

            {:error, error} ->  
                IO.puts(~s(Could not open file "#{filename}" because of error : ))
                IO.puts(~s[#{:file.format_error(error)}.])
        end
    end
end