defmodule Mystem do
  @moduledoc """
  Wrapper of the Yandex Mystem 3 morphological analyzer.
  Source info: https://yandex.ru/dev/mystem/
  """

  alias Mystem.Types

  @doc """
  Getting grammatical information and lemmas.
  """
  @spec analyze(binary()) :: Types.analyze_response()
  def analyze(text), do: Mystem.Pool.query({:analyze, text})

  @doc """
  Lemmatization.
  """
  @spec lemmatize(binary()) :: Types.lemmatize_response()
  def lemmatize(text), do: Mystem.Pool.query({:lemmatize, text})

  @doc """
  Lemmatization.
  """
  @spec lemmatize_word(binary()) :: Types.lemmatize_response()
  def lemmatize_word(text), do: Mystem.Pool.query({:lemmatize_word, text})
end
