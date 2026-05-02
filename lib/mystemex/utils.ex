defmodule Mystemex.Utils do
  @moduledoc """
  A set of utilities for working with text and analysis.
  """

  alias Mystemex.Types

  @spec contains_obscene?(String.t()) :: boolean()
  def contains_obscene?(text) do
    case Mystemex.analyze(text) do
      {:ok, analysis} ->
        analysis |> Enum.any?(&gr_match?(&1, "обсц"))

      _ ->
        false
    end
  end

  @spec fetch_obscene(String.t()) :: Types.analyze_response()
  def fetch_obscene(text) do
    case Mystemex.analyze(text) do
      {:ok, analysis} ->
        {:ok, analysis |> Enum.filter(&gr_match?(&1, "обсц"))}

      resp ->
        resp
    end
  end

  @spec fetch_nouns(String.t()) :: Types.analyze_response()
  def fetch_nouns(text) do
    case Mystemex.analyze(text) do
      {:ok, analysis} ->
        {:ok, analysis |> Enum.filter(&gr_starts_with?(&1, "S"))}

      resp ->
        resp
    end
  end

  @spec fetch_verbs(String.t()) :: Types.analyze_response()
  def fetch_verbs(text) do
    case Mystemex.analyze(text) do
      {:ok, analysis} ->
        {:ok, analysis |> Enum.filter(&gr_starts_with?(&1, "V"))}

      resp ->
        resp
    end
  end

  @spec gr_match?(Types.analysis_item(), String.t()) :: boolean()
  defp gr_match?(analysis_item, pattern) do
    case analysis_item do
      %{"analysis" => [%{"gr" => gr}]} when is_binary(gr) -> String.contains?(gr, pattern)
      _ -> false
    end
  end

  @spec gr_starts_with?(Types.analysis_item(), String.t()) :: boolean()
  defp gr_starts_with?(analysis_item, pattern) do
    case analysis_item do
      %{"analysis" => [%{"gr" => gr}]} when is_binary(gr) -> String.starts_with?(gr, pattern)
      _ -> false
    end
  end
end
