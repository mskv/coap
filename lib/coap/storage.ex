defmodule Coap.Storage do
  use GenServer

  @server_name Coap.Storage

  # GenServer interface

  def start_link(_args, _options) do
    GenServer.start_link(__MODULE__, [], name: @server_name)
  end

  def get(key) do
    GenServer.call(@server_name, {:get, key})
  end

  def set(key, change, overwrite \\ false) do
    GenServer.call(@server_name, {:set, key, change, overwrite})
  end

  # GenServer handlers

  def init(_args) do
    ets = :ets.new(@server_name, [:set, :private])
    {:ok, ets}
  end

  def handle_call({:get, key}, _from, ets) do
    {:reply, do_get(ets, key), ets}
  end

  def handle_call({:set, key, change, overwrite}, _from, ets) do
    {:reply, do_set(ets, key, change, overwrite), ets}
  end

  def handle_call(request, from, ets) do
    super(request, from, ets)
  end

  def handle_cast(request, ets) do
    super(request, ets)
  end

  # private

  defp do_get(ets, key) do
    case :ets.lookup(ets, key) do
      [{^key, value}] -> value
      _ -> :not_found
    end
  end

  defp do_set(ets, key, change, overwrite) do
    value = if(is_function(change), do: change.(do_get(ets, key)), else: change)
    insertion = if(overwrite, do: &:ets.insert/2, else: &:ets.insert_new/2)
    case insertion.(ets, {key, value}) do
      true -> value
      false -> false
    end
  end
end
