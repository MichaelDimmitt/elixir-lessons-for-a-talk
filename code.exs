## keywords: for, and case; "return a value so they can be assigned to a variable"

## Assign the value of the case statement to a variable
## To be able to inspect it and still return the value to the caller of the function.
def expand(code, shell \\ IEx.Broker.shell()) do
  var1 = case path_fragment(code) do
    [] -> expand_code(code, shell)
    path -> expand_path(path)
  end
  # IO.inspect({'beginning', foo, 'end'})
  var1
end

## The result of a for loop can be assigned to a variable.
defp container_context_map_fields(pairs, map, hint) do
  entries = # I did not write this code.
    for {key, _value} <- pairs,
        name = Atom.to_string(key),
        if(hint == "",
          do: not String.starts_with?(name, "_"),
          else: String.starts_with?(name, hint)
        ),
        do: %{kind: :keyword, name: name}
  entries |> IO.inspect
  entries
end

## Debug this module:
:int.ni (IEx.Autocomplete)

## Debug this module at line 8: (did not work for me.)
:int.ni (IEx.Autocomplete, 8)


## How would you debug the case statement here?
case Code.Fragment.cursor_context(code) do
  {:alias, alias} ->
    expand_aliases(List.to_string(alias), shell)

  {:unquoted_atom, , unquoted_atom} -> IO.inspect()
  #...
end

## Answer: (find the value powering the case statement);
# IO.inspect(Code.Fragment.cursor_context(code))

## How would you debug this case statement?
defp expand_dot(path, hint, exact?, shell) do
  case expand_dot_path(path, shell) do
    {:ok, mod} when is_atom(mod) and hint == "" -> expand_dot_aliases(mod)
    {:ok, mod} when is_atom(mod) -> expand_require(mod, hint, exact?)
    {:ok, map} when is_map(map) -> expand_map_field_access(map, hint)
    _ -> no()
  end
end

## Answer: (to capture all destructuring values, use a new case statement above the case statement under inspection.)
defp expand_dot(path, hint, exact?, shell) do
  # case expand_dot_path(path, shell) do
  #   {:ok, mod } -> IO.inspect({'hi', expand_dot_path(path, shell),is_atom(mod), is_map(mod), expand_dot_aliases(mod), hint})
  # end

  case expand_dot_path(path, shell) do
    {:ok, mod} when is_atom(mod) and hint == "" -> expand_dot_aliases(mod)
    {:ok, mod} when is_atom(mod) -> expand_require(mod, hint, exact?)
    {:ok, map} when is_map(map) -> expand_map_field_access(map, hint)
    _ -> no()
  end
end
