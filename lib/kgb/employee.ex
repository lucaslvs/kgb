defmodule KGB.Employee do
  @enforce_keys [:name, :rating]

  defstruct @enforce_keys
end
