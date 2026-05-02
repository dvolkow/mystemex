defmodule MystemexTest do
  use ExUnit.Case
  doctest Mystemex

  @test_text "мама мыла раму"
  @analyze_ref {:ok,
                [
                  %{
                    "analysis" => [
                      %{"gr" => "S,жен,од=им,ед", "lex" => "мама", "wt" => 1}
                    ],
                    "text" => "мама"
                  },
                  %{
                    "analysis" => [
                      %{
                        "gr" => "V,несов,пе=прош,ед,изъяв,жен",
                        "lex" => "мыть"
                      }
                    ],
                    "text" => "мыла"
                  },
                  %{
                    "analysis" => [
                      %{
                        "gr" => "S,жен,неод=вин,ед",
                        "lex" => "рама"
                      }
                    ],
                    "text" => "раму"
                  }
                ]}
  @lemmatize_ref {:ok, ["мама", "мыть", "рама"]}
  @lemmatize_word_ref {:ok, "мама"}

  test "analyze" do
    # NOTE: patter matching, reference without wt witch is float
    assert @analyze_ref = Mystemex.analyze(@test_text)
  end

  test "lemmatize" do
    assert @lemmatize_ref == Mystemex.lemmatize(@test_text)
  end

  test "lemmatize_word" do
    assert @lemmatize_word_ref == Mystemex.lemmatize_word(@test_text)

    assert @lemmatize_word_ref == Mystemex.lemmatize_word(@test_text |> String.split() |> hd)
  end
end
