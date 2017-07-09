# Depz

Command line tools for mix dependencies

[![Build Status](https://travis-ci.org/MainShayne233/depz.svg?branch=master)](https://travis-ci.org/MainShayne233/depz)
[![Code Climate](https://codeclimate.com/github/MainShayne233/depz/badges/gpa.svg)](https://codeclimate.com/github/MainShayne233/depz)


## Current State

Though functional, this tool is still in early development.

Since it writes to disk, it can literally wipe out any important information/data
you may have in your `mix.exs` file, so proceed with absolute caution.


## Install

This is a package you install globally on your machine using `mix archive.install`, like so:

```bash
mix archive.install github MainShayne233/depz
```

## Usage

To add a dependency to your `mix.exs` file, from your app's directory run:

```bash
mix depz.add httpotion

# or for a specific version

mix depz.add httpotion -v 3.0.1
```

If you don't specify the version, it defaults to the latest version from [hex.pm](https://hex.pm)

## Dependency List Style

Elixir allows you to define your dependency list in `mix.exs` with whatever style you want, like
```
[{:httpotion, "~> 3.0.2"},
 {:phoenix, "~> 1.3"},
 {:calendar, "~> 1.2.3"}]
```

or

```
[
  {:httpotion, "~> 3.0.2"},
  {:phoenix, "~> 1.3"},
  {:calendar, "~> 1.2.3"},
]
```

This tool tries to identify what style you are using and maintain it when adding a new dependency.
