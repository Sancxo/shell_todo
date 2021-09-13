defmodule ShellTodo do
    def start() do
       load_csv()
    end

    def add_task(data) do
        get_name(data)

        # get_command(new_data)
    end

    def delete_task(data) do
        todo = IO.gets("Which task do you want to delete ?\n") |> String.trim
        if Map.has_key?(data, todo) do
            IO.puts("Ok !")
            new_map = Map.drop(data, [todo])
            IO.puts(~s("#{todo}" has succefully been deleted.))
            get_command(new_map)
        else 
            IO.puts(~s(There is no todo named "#{todo}" ...))
            show_tasks(data, false)
            delete_task(data)
        end
    end

    def get_command(data) do
        prompt = """
Type the first letter of the command you want to run :

Show tasks    Add a task    Delete a task    Load a .csv    Save a .csv    Quit

"""
        command = IO.gets(prompt)
            |> String.trim()
            |> String.downcase()

        case command do
            "s" -> show_tasks(data)
            "a" -> add_task(data)
            "d" -> delete_task(data)
            "l" -> load_csv()
            # "s" -> 
            "q" -> "Goodbye mate !"
            _   -> get_command(data)
        end
    end

    def get_name(data) do
        name = IO.gets("Enter the name of the new task : ") |> String.trim

        if Map.has_key?(data, name) do
            IO.puts("This task already exists ! \n")
            get_name(data)
        else
            name
        end
    end

    def load_csv() do
        filename = IO.gets("Name of the file.csv to load: ") |> String.trim()
        read(filename)
            |> parse()
            |> get_command()
    end

    def parse(body) do
        [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
        titles = tl String.split(header, ",")
        parse_lines(lines, titles)
    end

    def parse_lines(lines, titles) do
        Enum.reduce(lines, %{}, fn line, built ->
            [name | fields] = String.split(line, ",")
            if Enum.count(fields) == Enum.count(titles) do
                line_data = Enum.zip(titles, fields) |> Enum.into(%{})
                Map.merge(built, %{name => line_data})
            else 
                built
            end
        end)
    end

    def read(filename) do
        case File.read(filename) do
            {:ok, body} ->
                body
            {:error, error} ->  
                IO.puts(~s(Could not open file "#{filename}" because of error : ))
                IO.puts(~s[#{:file.format_error(error)}.])
                start()
        end
    end

    def show_tasks(data, next_command? \\ true) do
        items = Map.keys(data)
        IO.puts("You have the following tasks to do :\n")
        Enum.each(items, fn item -> IO.puts(item) end)
        IO.puts("\n")
        if next_command? do
            get_command(data)
        end
    end
end