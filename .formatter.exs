[
  import_deps: [:phoenix, :ash, :ash_phoenix, :typedstruct],
  plugins: [Phoenix.LiveView.HTMLFormatter, PrettierFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "assets/js/**/*.{js,ts,jsx,tsx}",
    "assets/tailwind.config.js",
    "assets/css/**/*.css"
  ]
]
