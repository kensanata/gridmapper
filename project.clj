(defproject gridmapper "1.0.0"
  :description "Utility to create simple dungeon maps for role-playing games."
  :url "https://github.com/kensanata/gridmapper"
  :license {:name "CC0 1.0 Universal"
            :url "http://creativecommons.org/publicdomain/zero/1.0/"}
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [com.keminglabs/c2 "0.2.1"]]
  :min-lein-version "2.0.0"
  :source-paths ["src/clj"]

  :plugins [[lein-cljsbuild "0.2.7"]]

  :cljsbuild {
    :builds [{
      :source-path "src/cljs"
      :compiler {
        :output-to "public/out/gridmapper.js"
        :optimizations :whitespace
        :pretty-print true }}]}

  :main ^:skip-aot gridmapper.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
