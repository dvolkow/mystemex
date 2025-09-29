defmodule Mystem do
  @moduledoc """
  Wrapper of the Yandex Mystem 3 morphological analyzer.
  Source info: https://yandex.ru/dev/mystem/
  """

  @doc """
  Getting grammatical information and lemmas.
  """
  def analyze(text), do: Mystem.Pool.query({:analyze, text})

  @doc """
  Lemmatization.
  """
  def lemmatize(text), do: Mystem.Pool.query({:lemmatize, text})

  @doc """
  Lemmatization.
  """
  def lemmatize_one(text), do: Mystem.Pool.query({:lemmatize_one, text})
end
