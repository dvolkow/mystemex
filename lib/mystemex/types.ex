defmodule Mystemex.Types do
  @moduledoc """
  Here are the types that are used in Mystemex.
  """

  @type base_response(a) :: {:ok, a} | {:exit_code, integer()} | {:error, String.t()}
  @type analysis_item() :: %{
          required(:gr) => String.t(),
          required(:lex) => String.t(),
          required(:wt) => float(),
          optional(:qual) => String.t()
        }
  @type analyze_items() :: [
          %{
            required(:analysis) => [analysis_item()],
            required(:text) => String.t()
          }
        ]

  @type analyze_response() :: base_response(analyze_items())
  @type lemmatize_response() :: base_response(list(String.t()))
  @type lemmatize_word_response() :: base_response(String.t())

  @type responses() :: analyze_response() | lemmatize_response() | lemmatize_word_response()

  @type query_kind() :: :analyze | :lemmatize | :lemmatize_word
  @type query_type() :: {query_kind(), String.t()}
end
