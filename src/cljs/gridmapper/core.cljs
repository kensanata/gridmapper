(ns gridmapper.core
  (:use-macros [c2.util :only [bind! p]])
  (:use [c2.core :only [unify]]
        [c2.event :only [on]])
  (:require [c2.scale :as scale]))

(defrecord Cell [x y tile])

(defn make-grid
  ([dim]
     (make-grid dim dim dim (set nil)))
  ([x y maxy grid]
     (cond (> y 0)
           (make-grid x (- y 1) maxy (conj grid (Cell. x y "empty")))
           (> x 0)
           (make-grid (- x 1) maxy maxy (conj grid (Cell. x y "empty")))
           true
           (conj grid (Cell. x y "empty")))))

;; this is our model
(def model {:dim 30
            :grid (atom (make-grid 30))})

(defn set-tile [cell tile]
  (p tile)
  (let [grid @(:grid model)]
    (reset! (:grid model)
            (conj (disj grid cell)
                  (Cell. (:x cell) (:y cell) tile)))))

;; this is the view       
(bind! "#mapper"
       (let [dim (:dim model)
             width 20
             grid @(:grid model)
             s (scale/linear :domain [0 dim]
                             :range [0 (* dim width)])]
         
         [:div
                     
          [:svg {:xmlns "http://www.w3.org/2000/svg"
                 ;; :xmlns:xlink "http://www.w3.org/1999/xlink"
                 :height (* dim width) :width (* dim width) }
           
           ;; [:defs
           ;;  [:rect#empty {:x 0 :y 0 :height width :width width :fill "#555" :stroke "#000"}]
           ;;  [:rect#floor {:x 0 :y 0 :height width :width width :fill "#fff" :stroke "#000"}]]

           [:g#grid
            
            (unify grid
                   (fn [cell]

                     (cond (= (:tile cell) "floor")
                           [:rect#floor {:x (s (:x cell)) :y (s (:y cell))
                                         :height width :width width :fill "#fff" :stroke "#000"}]
                           (= (:tile cell) "empty")
                           [:rect#empty {:x (s (:x cell)) :y (s (:y cell))
                                         :height width :width width :fill "#555" :stroke "#000"}])
                     
                     ;; [:use {:xlink:href (str "#" (:tile cell))
                     ;;        :x (s (:x cell))
                     ;;        :y (s (:y cell))}]

                     ))]]]))

(on "#grid"
    :click
    (fn [cell]
      (p cell)
      (if (= (:tile cell) "floor")
        (set-tile cell "empty")
        (set-tile cell "floor"))))
