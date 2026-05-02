# Mystemex

The Elixir wrapper of the [Yandex Mystem 3 morphological analyzer](https://yandex.ru/dev/mystem/) for Russian language.

## A Quick Example

Lemmatization:

```elixir
iex(1)> text = "Красивая мама красиво мыла раму"
"Красивая мама красиво мыла раму"
iex(2)> {:ok, lemmas} = Mystemex.lemmatize(text)
{:ok,
["красивый", "мама", "красиво", "мыть", "рама"]}
```

Getting grammatical information and lemmas:

```elixir
iex(4)> {:ok, analyze} = Mystemex.analyze(text)
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

You can find usage examples in `test` directory.

**Types**

Return value types are described in `Mystemex.Types`

**Settings**

See `config/configs.exs`.

`mystem_path` is path to your Mystem binaries;

`pool_size` is size of workers pool;

`pool_max_overflow` is max overflow for pool size.


## Installation

1. Install `mystem` binary package to your system. Download from here: [https://yandex.ru/dev/mystem/](https://yandex.ru/dev/mystem/)

2. If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mystemex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mystemex, "~> 0.2.0"}
  ]
end

```

or build from this source:

```
mix deps.get
mix compile
```

3. Setup Mystem binaries path (`:mystemex, :mystem_path` in your config).


## ⚠️ License Notice
This library is MIT-licensed, but Mystem itself is proprietary Yandex software.
You must download it separately and accept its license.
