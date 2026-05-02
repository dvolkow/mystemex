defmodule MystemexUtilsTest do
  use ExUnit.Case
  doctest Mystemex

  @test_text "красивая мама красиво мыла красивую раму"
  @nouns_ref {:ok, [%{"text" => "мама"}, %{"text" => "раму"}]}
  @verbs_ref {:ok, [%{"text" => "мыла"}]}

  test "nouns" do
    assert @nouns_ref = Mystemex.Utils.fetch_nouns(@test_text)
  end

  test "verbs" do
    assert @verbs_ref = Mystemex.Utils.fetch_verbs(@test_text)
  end
end
