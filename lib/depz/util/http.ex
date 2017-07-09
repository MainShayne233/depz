defmodule Depz.Util.HTTP do

  @adapter if Mix.env == :test, do: __MODULE__.TestAdapter, else: __MODULE__.HTTPAdapter

  def get(url) do
    url
    |> @adapter.get
    |> case do
      {:ok, {{_, 200, 'OK'}, _, body}} ->
        {:ok, body |> to_string}
      _other ->
        {:error, :not_found}
    end
  end

  defmodule HTTPAdapter do

    def get(url) do
      with :ok <- :ssl.start(),
           :ok <- :inets.start() do
        url = String.to_charlist(url)
        :httpc.request(:get, {url, [{'User-Agent', 'httpc'}]}, [], [])
      end
    end
  end

  defmodule TestAdapter do
    def get("https://hex.pm/api/packages/httpotion") do
      {:ok,
       {{'HTTP/1.1', 200, 'OK'},
        [{'cache-control', 'public, max-age=60'}, {'connection', 'keep-alive'},
         {'date', 'Sun, 09 Jul 2017 22:06:36 GMT'}, {'via', '1.1 vegur'},
         {'etag', '2a5dca54fcff28015cd9732dc07b7b71'}, {'server', 'Cowboy'},
         {'vary', 'accept, accept-encoding, accept-encoding'},
         {'content-length', '2061'},
         {'content-type', 'application/vnd.hex+json; charset=utf-8'},
         {'last-modified', 'Sun, 15 Jan 2017 01:34:31 GMT'},
         {'strict-transport-security', 'max-age=31536000'},
         {'x-ratelimit-limit', '100'}, {'x-ratelimit-remaining', '99'},
         {'x-ratelimit-reset', '1499638020'}],
        '{"url":"https://hex.pm/api/packages/poison","updated_at":"2017-01-15T01:34:31.327060Z","releases":[{"version":"3.1.0","url":"https://hex.pm/api/packages/poison/releases/3.1.0"},{"version":"3.0.0","url":"https://hex.pm/api/packages/poison/releases/3.0.0"},{"version":"2.2.0","url":"https://hex.pm/api/packages/poison/releases/2.2.0"},{"version":"2.1.0","url":"https://hex.pm/api/packages/poison/releases/2.1.0"},{"version":"2.0.1","url":"https://hex.pm/api/packages/poison/releases/2.0.1"},{"version":"2.0.0","url":"https://hex.pm/api/packages/poison/releases/2.0.0"},{"version":"1.5.2","url":"https://hex.pm/api/packages/poison/releases/1.5.2"},{"version":"1.5.1","url":"https://hex.pm/api/packages/poison/releases/1.5.1"},{"version":"1.5.0","url":"https://hex.pm/api/packages/poison/releases/1.5.0"},{"version":"1.4.0","url":"https://hex.pm/api/packages/poison/releases/1.4.0"},{"version":"1.3.1","url":"https://hex.pm/api/packages/poison/releases/1.3.1"},{"version":"1.3.0","url":"https://hex.pm/api/packages/poison/releases/1.3.0"},{"version":"1.2.1","url":"https://hex.pm/api/packages/poison/releases/1.2.1"},{"version":"1.2.0","url":"https://hex.pm/api/packages/poison/releases/1.2.0"},{"version":"1.1.1","url":"https://hex.pm/api/packages/poison/releases/1.1.1"},{"version":"1.1.0","url":"https://hex.pm/api/packages/poison/releases/1.1.0"},{"version":"1.0.3","url":"https://hex.pm/api/packages/poison/releases/1.0.3"},{"version":"1.0.2","url":"https://hex.pm/api/packages/poison/releases/1.0.2"},{"version":"1.0.1","url":"https://hex.pm/api/packages/poison/releases/1.0.1"},{"version":"1.0.0","url":"https://hex.pm/api/packages/poison/releases/1.0.0"}],"owners":[{"username":"devinus","url":"https://hex.pm/api/users/devinus","email":"devin@devintorr.es"}],"name":"poison","meta":{"maintainers":["Devin Torres"],"links":{"GitHub":"https://github.com/devinus/poison"},"licenses":["CC0-1.0"],"description":"An incredibly fast, pure Elixir JSON library"},"inserted_at":"2014-08-20T04:43:51.000000Z","downloads":[{"week":38466},{"all":3272561},{"day":2361}]}'}}
    end

    def get("https://hex.pm/api/packages/poision") do
      {:ok,
       {{'HTTP/1.1', 404, 'Not Found'},
  [{'cache-control', 'max-age=0, private, must-revalidate'},
   {'connection', 'keep-alive'}, {'date', 'Sun, 09 Jul 2017 23:26:31 GMT'},
   {'via', '1.1 vegur'}, {'server', 'Cowboy'}, {'vary', 'accept-encoding'},
   {'content-length', '5895'}, {'content-type', 'text/html; charset=utf-8'},
   {'strict-transport-security', 'max-age=31536000'},
   {'x-frame-options', 'SAMEORIGIN'}, {'x-xss-protection', '1; mode=block'},
   {'x-content-type-options', 'nosniff'}],
  '<!DOCTYPE html>\n<html lang="en" prefix="og: http://ogp.me/ns#">\n  <head>\n    <meta charset="utf-8">\n    <meta http-equiv="X-UA-Compatible" content="IE=edge">\n    <meta name="viewport" content="width=device-width, initial-scale=1">\n    <meta name="description" content="A package manager for the Erlang ecosystem">\n\n    <title>Hex</title>\n\n<meta property="og:title"><meta content="website" property="og:type"><meta property="og:url"><meta content="https://hex.pm/images/favicon-160-93fa091b05b3e260e24e08789344d5ea.png?vsn=d" property="og:image"><meta content="160" property="og:image:width"><meta content="160" property="og:image:height"><meta content="A package manager for the Erlang ecosystem" property="og:description"><meta content="Hex" property="og:site_name">\n    <link rel="search" type="application/opensearchdescription+xml" title="Hex" href="/hexsearch.xml">\n    <link rel="stylesheet" href="/css/app-f4c589d2829e24c6906e081df48d3199.css?vsn=d">\n    <link rel="shortcut icon" href="/favicon-acecbef334adb3141ce09929f639155c.png?vsn=d">\n  </head>\n  <body>\n    <!--[if lt IE 10]>\n      <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>\n    <![endif]-->\n\n    <nav class="navbar navbar-default navbar-fixed-top">\n      <div class="container">\n        <div class="navbar-header">\n          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">\n            <span class="sr-only">Toggle navigation</span>\n            <span class="icon-bar"></span>\n            <span class="icon-bar"></span>\n            <span class="icon-bar"></span>\n          </button>\n          <a class="navbar-brand" href="/">\n            <img src="/images/hex-a56f59a0c6bb92a0e2850ccd555f7525.png?vsn=d" srcset="/images/hex-a56f59a0c6bb92a0e2850ccd555f7525.png?vsn=d 1x, /images/hex@2-844f591d7bbac6a50d895110a643c670.png?vsn=d 2x, /images/hex@3-b88c46c5ec4e807f1daef99e4dd1f231.png?vsn=d 3x" alt="hex logo">\n          </a>\n        </div>\n        <div id="navbar" class="navbar-collapse collapse">\n          <form class="navbar-form pull-left" role="search" action="/packages">\n             <div class="input-group">\n                <input placeholder="Find packages" name="search" type="text" autofocus class="form-control" value="">\n                <input type="hidden" name="sort" value="downloads">\n\n                <div class="input-group-btn">\n                  <button type="submit" class="btn btn-search" tabindex="1">\n<svg aria-hidden="aria-hidden" class="glyphicon glyphicon-search" version="1.1" viewBox="0 0 1200 1200"><g transform="translate(0, 1200) scale(1, -1)"><path d="M500 1191q100 0 191 -39t156.5 -104.5t104.5 -156.5t39 -191l-1 -2l1 -5q0 -141 -78 -262l275 -274q23 -26 22.5 -44.5t-22.5 -42.5l-59 -58q-26 -20 -46.5 -20t-39.5 20l-275 274q-119 -77 -261 -77l-5 1l-2 -1q-100 0 -191 39t-156.5 104.5t-104.5 156.5t-39 191 t39 191t104.5 156.5t156.5 104.5t191 39zM500 1022q-88 0 -162 -43t-117 -117t-43 -162t43 -162t117 -117t162 -43t162 43t117 117t43 162t-43 162t-117 117t-162 43z"></path></g></svg>                  </button>\n                </div>\n             </div>\n          </form>\n\n          <ul class="nav navbar-nav navbar-right">\n            <li><a href="/packages">Packages</a></li>\n\n            <li class="dropdown">\n              <a href="#" class="dropdown-toggle" data-toggle="dropdown">Documentation <b class="caret"></b></a>\n              <ul class="dropdown-menu">\n                <li class="dropdown-header menu-dropdown-header">Mix</li>\n                <li><a href="/docs/usage">Usage</a></li>\n                <li><a href="/docs/publish">Publishing packages</a></li>\n                <li><a href="/docs/tasks">Tasks</a></li>\n                <li role="separator" class="divider"></li>\n                <li class="dropdown-header menu-dropdown-header">Rebar3</li>\n                <li><a href="/docs/rebar3_usage">Usage</a></li>\n                <li><a href="/docs/rebar3_publish">Publishing packages</a></li>\n                <li><a href="https://www.rebar3.org/v3.0/docs/hex-package-management">Tasks</a></li>\n                <li role="separator" class="divider"></li>\n                <li><a href="/policies">Policies</a></li>\n                <li><a href="/docs/mirrors">Mirrors</a></li>\n                <li><a href="/docs/public_keys">Public keys</a></li>\n                <li><a href="https://github.com/hexpm/specifications">Specifications</a></li>\n              </ul>\n            </li>\n\n              <li><a href="/login">Log in</a></li>\n\n          </ul>\n        </div><!--/.nav-collapse -->\n      </div>\n    </nav>\n\n\n    <div class="container error-view">\n<h1>404</h1>\n<span class="message">Page not found</span>\n    </div>\n\n    <div class="footer">\n      <div class="footer-nav">\n        <div class="container">\n          <ul>\n            <li>\n              <a href="https://github.com/hexpm">github</a>\n            </li>\n            <li>\n              <a href="/policies">policies</a>\n            </li>\n            <li>\n              <a href="/sponsors">sponsors</a>\n            </li>\n            <li>\n              <a href="mailto:support@hex.pm">support</a>\n            </li>\n          </ul>\n        </div>\n      </div>\n    </div>\n\n    <script src="/js/app-2731821bc3e3f274297d5308fb951734.js?vsn=d"></script>\n\n    <script>\n      (function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;i[r]=i[r]||function(){\n      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n      })(window,document,\'script\',\'//www.google-analytics.com/analytics.js\',\'ga\');\n\n      ga(\'create\', \'UA-49056880-1\', \'auto\');\n      ga(\'send\', \'pageview\');\n    </script>\n\n  </body>\n</html>\n'}}
    end
  end
end
