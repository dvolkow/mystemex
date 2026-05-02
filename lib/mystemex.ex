defmodule Mystemex do
  @moduledoc """
  Wrapper of the Yandex Mystem 3 morphological analyzer for Russian language.
  Source info: https://yandex.ru/dev/mystem/
  """

  alias Mystemex.{Types, Pool}

  @doc """
  Getting grammatical information and lemmas. For each word
  in the text you get Mystemex.Types.analysis_item() with linguistic
  information.
  """
  @spec analyze(binary()) :: Types.analyze_response()
  def analyze(text), do: Pool.query({:analyze, text})

  @doc """
  Lemmatization for text. Return list of lemmatized words.
  The words are ordered the same way as in the original text.
  """
  @spec lemmatize(binary()) :: Types.lemmatize_response()
  def lemmatize(text), do: Pool.query({:lemmatize, text})

  @doc """
  Lemmatization for one word. Return ONE lemmatized word.

  If text with more than one word was passed, the first word
  processed will be returned.

  Works a little faster if you really need to lemmatize one word.
  """
  @spec lemmatize_word(binary()) :: Types.lemmatize_word_response()
  def lemmatize_word(text), do: Pool.query({:lemmatize_word, text})
end
