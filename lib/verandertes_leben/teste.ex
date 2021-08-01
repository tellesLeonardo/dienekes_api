defmodule Sort do
  def mergesort(l) when length(l) < 2, do: l
  def mergesort(l) do
    {left, right} = Enum.split(l, div(length(l), 2))
    spawn_link(Sort, :mergesort, [left, self()])
    spawn_link(Sort, :mergesort, [right, self()])
    merge()
  end
  def mergesort(l, parent) when length(l) < 2, do: send(parent, l)
  def mergesort(l, parent) do
    {left, right} = Enum.split(l, div(length(l), 2))
    spawn_link(Sort, :mergesort, [left, self()])
    spawn_link(Sort, :mergesort, [right, self()])
    # apply(Sort, :mergesort, [right, self()])
    # Process.send(self(), {:mergesort, [left, self()]}, [:noconnect])
    # Process.send(self(), {:mergesort, [right, self()]}, [:noconnect])

    send(parent, merge())
  end

  def merge do
    receive do
      list -> merge(list)
    end
  end
  def merge(left) do
    receive do
      right -> :lists.merge(left, right)
    end
  end
end
