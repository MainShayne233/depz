use Mix.Config

if Mix.env == :dev do
  config :mix_test_watch,
    exclude: [~r/test_app\/.*/]
end
