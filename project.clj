(defproject gridmapper "0.9.9"
  :description "Utility to create simple dungeon maps for role-playing games."
  :url "https://github.com/kensanata/gridmapper"
  :license {:name "CC0 1.0 Universal"
            :url "http://creativecommons.org/publicdomain/zero/1.0/"}
  :dependencies [[org.clojure/clojure "1.5.1"]]
  :main ^:skip-aot gridmapper.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
