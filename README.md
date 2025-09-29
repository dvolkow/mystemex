# Mystem

The Elixir wrapper of the Yandex Mystem 3 morphological analyzer

## A Quick Example

Lemmatization

```elixir
iex(1)> text = "Красивая мама красиво мыла раму"
"Красивая мама красиво мыла раму"
iex(2)> {:ok, lemmas} = Mystem.lemmatize(text)
{:ok,
["красивый", "мама", "красиво", "мыть", "рама"]}
iex(3)> lemmas |> Enum.join(" ")
"красивый мама красиво мыть рама"
```

Getting grammatical information and lemmas.

```elixir
iex(4)> {:ok, analyze} = Mystem.analyze(text)
{:ok,
  [
    %{
      "analysis" => [
        %{
          "gr" => "A=им,ед,полн,жен",
          "lex" => "красивый",
          "wt" => 1
        }
      ],
      "text" => "Красивая"
    },
    %{
      "analysis" => [
        %{"gr" => "S,жен,од=им,ед", "lex" => "мама", "wt" => 1}
      ],
      "text" => "мама"
    },
    %{
      "analysis" => [
        %{"gr" => "ADV=", "lex" => "красиво", "wt" => 0.8149252476}
      ],
      "text" => "красиво"
    },
    %{
      "analysis" => [
        %{
          "gr" => "V,несов,пе=прош,ед,изъяв,жен",
          "lex" => "мыть",
          "wt" => 0.441520999
        }
      ],
      "text" => "мыла"
    },
    %{
      "analysis" => [
        %{
          "gr" => "S,жен,неод=вин,ед",
          "lex" => "рама",
          "wt" => 0.9993591156
        }
      ],
      "text" => "раму"
    }
]}
```

**Dependencies**

Need install `mystem` binary file to your .local/bin directory:

```
~/.local/bin/mystem
```

**Settings**

`pool_size` -- size of workers pool;

`pool_max_overflow` -- max overflow for pool size.


## Installation

```
mix deps.get
mix compile
```

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mystemex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mystemex, "~> 0.1.0"}
  ]
end
```
