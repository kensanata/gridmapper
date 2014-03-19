(ns gridmapper.core-test
  (:import (javax.swing JPanel)
  	   (java.awt GridBagLayout))
  (:require [clojure.test :refer :all]
            [gridmapper.core :refer :all]))

(deftest grid-test
  (testing "Create a grid"
    (is (let [panel (doto (JPanel. (GridBagLayout.))
		      (simple-grid 5 5))]
          (find-cell 1 1)))))
