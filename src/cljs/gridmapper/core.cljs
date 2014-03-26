(ns gridmapper.core
  (:use-macros [c2.util :only [bind! p]])
  (:use [c2.core :only [unify]]
        [c2.event :only [on]])
  (:require [c2.scale :as scale]
            [c2.dom :as dom]))

;; --------------------------------------------------

;; this is our model

(defrecord Cell [x y tile s-wall e-wall])

(defn make-grid
  ([dim]
     (make-grid (- dim 1) (- dim 1) (- dim 1) (set nil)))
  ([x y maxy grid]
     (cond (> y 0)
           (make-grid x (- y 1) maxy (conj grid (Cell. x y :empty :empty :empty)))
           (> x 0)
           (make-grid (- x 1) maxy maxy (conj grid (Cell. x y :empty :empty :empty)))
           true
           (conj grid (Cell. x y :empty :empty :empty)))))

(let [dim 3 width 20]
  (def model {:dim dim ;; cells
              :width width ;; pixels
              :scale (scale/linear :domain [0 dim]
                                   :range [0 (* dim width)])
              :grid (atom (make-grid dim))
              :pen (atom nil)
              :mode (atom "door")}))

;; --------------------------------------------------

;; this is the view       

(bind! "#mapper"
       (let [dim (:dim model)
             width (:width model)
             grid @(:grid model)
             s (:scale model)
             buttons [{:key "d" :pos 0 :id "door" :description "door"}
                      {:key "$" :pos 1 :id "secret" :description "secret door"}
                      {:key "t" :pos 2 :id "trap" :description "trap"}]]
         
         [:div
                     
          [:svg {:xmlns "http://www.w3.org/2000/svg"
                 :width (+ (* dim width) 200) ;; add sidebar for buttons
                 :height (* dim width)}
           
           [:g#grid
            (unify grid
                   (fn [cell]
                     [:rect {:x (s (:x cell)) :y (s (:y cell))
                             :height width :width width :stroke "#000"
                             :fill (if (= (:tile cell) :floor) "#fff" "#555")}]))]

           [:g#sdoors
            (unify grid
                   (fn [cell]
                     [:g ;; even cells without doors need this group
                      {:id (str "sdoor" (:x cell) "_" (:y cell))}
                      (when (< (:y cell) (- dim 1))
                        [:rect.south {:x (s (:x cell)) :y (s (+ (:y cell) 0.8))
                                      :height (* width 0.4) :width width
                                      :opacity 0.2}])
                      (when (not (= (:s-wall cell) :empty))
                        [:g
                         [:rect] ;; keep the default rect
                         [:line.wall  {:x1 (s (:x cell)) :y1 (s (+ (:y cell) 1))
                                       :x2 (s (+ (:x cell) 1)) :y2 (s (+ (:y cell) 1))
                                       :stroke-width 4 :stroke "#000"}]
                         [:rect.door  {:x (s (+ (:x cell) 0.2)) :y (s (+ (:y cell) 0.85))
                                       :height (* width 0.3) :width (* width 0.6)
                                       :fill "#fff" :stroke-width 1 :stroke "#000"}]])]))]

           [:g#edoors
            (unify grid
                   (fn [cell]
                     [:g ;; even cells without doors need this group
                      {:id (str "edoor" (:x cell) "_" (:y cell))}
                      (when (< (:x cell) (- dim 1))
                        [:rect.east {:x (s (+ (:x cell) 0.8)) :y (s (:y cell))
                                     :height width :width (* width 0.4)
                                     :opacity 0.2}])
                      (when (not (= (:e-wall cell) :empty))
                        [:g
                         [:rect] ;; keep the default rect
                         [:line.wall  {:x1 (s (+ (:x cell) 1)) :y1 (s (:y cell))
                                       :x2 (s (+ (:x cell) 1)) :y2 (s (+ (:y cell) 1))
                                       :stroke-width 4 :stroke "#000"}]
                         [:rect.door  {:x (s (+ (:x cell) 0.85)) :y (s (+ (:y cell) 0.2))
                                       :height (* width 0.6) :width (* width 0.3)
                                       :fill "#fff" :stroke-width 1 :stroke "#000"}]])]))]

           [:g#buttons
            (unify buttons
                   (fn [{:keys [key pos id description]}]
                     [:g {:id id :class "button"}
                      ;; frame around button
                      [:rect {:x (+ (* dim width) 50)
                              :y (+ (* 100 pos) 20)
                              :width 80
                              :height 80
                              :fill "#fff"
                              :stroke "#000"
                              :stroke-width 2}]
                      ;; key
                      [:text {:x (+ (* dim width) 90)
                              :y (+ (* 100 pos) 60)
                              :text-anchor "middle"
                              :alignment-baseline "middle"
                              :font-size 50
                              :font-family "Courrier"
                              :fill "#000"}
                       key]
                      ;; description
                      [:text {:x (+ (* dim width) 90)
                              :y (+ (* 100 pos) 95)
                              :text-anchor "middle"
                              :font-size 12
                              :font-family "Courrier"
                              :fill "#000"}
                       description]]))]]]))

;; --------------------------------------------------

;; this is the controller

(defn set-tile [cell tile]
  ;; (p (str "set-tile "tile))
  (when tile
    (let [grid @(:grid model)]
      (reset! (:grid model)
              (conj (disj grid cell)
                    (Cell. (:x cell) (:y cell) tile (:s-wall cell) (:e-wall cell)))))))

(defn draw-on [cell]
  ;; use whatever the pen says
  ;; (p "draw-on")
  (set-tile cell @(:pen model)))

(defn set-pen [cell]
  ;; eventually this should depend on the mode
  (reset! (:pen model)
          (cond (not cell); no pen
                nil
                (= (:tile cell) :floor)
                :empty
                (= (:tile cell) :empty)
                :floor
                true; current tile is undefined
                nil)))

(defn set-mode [mode]
  (reset! (:mode model) mode))

(defn set-south-wall [cell mode]
  (when mode
    (let [grid @(:grid model)
          width (:width model)
          s (:scale model)
          new-cell (Cell. (:x cell) (:y cell)
                          (:tile cell)
                          (if (= (:s-wall cell) :empty) mode :empty)
                          (:e-wall cell))
          door-id (str "#sdoor" (:x cell) "_" (:y cell))]
      ;; update model
      (reset! (:grid model)
              (conj (disj grid cell) new-cell)))))

(defn draw-south-wall [cell]
  (set-south-wall cell @(:mode model)))

(defn set-east-wall [cell mode]
  (when mode
    (let [grid @(:grid model)
          width (:width model)
          s (:scale model)
          new-cell (Cell. (:x cell) (:y cell)
                          (:tile cell)
                          (:s-wall cell)
                          (if (= (:e-wall cell) :empty) mode :empty))
          door-id (str "#edoor" (:x cell) "_" (:y cell))]
      ;; update model
      (reset! (:grid model)
              (conj (disj grid cell) new-cell)))))

(defn draw-east-wall [cell]
  (set-east-wall cell @(:mode model)))

;; installing handlers

(on "#grid" :mousedown
    (fn [cell]
      ;; (p "down")
      (set-pen cell)))

(on "#grid" :mouseup
    (fn [cell]
      ;; (p "up")
      (set-pen nil)))

;; FIXME: add code to interpolate missed cells

(on "#grid" :mousemove
    (fn [cell]
      (draw-on cell)))

;; a click is DOWN UP CLICK -- so the pen is NIL again

(on "#grid" :click
    (fn [cell]
      ;; (p "click")
      (set-pen cell)
      (draw-on cell)
      (set-pen nil)))

;; FIXME: keypresses still don't work

(on "#grid" :keypress
    (fn [cell node event]
      (p event)))

(on "#sdoors" :click
    (fn [cell]
      (draw-south-wall cell)))

(on "#edoors" :click
    (fn [cell]
      (draw-east-wall cell)))

;; buttons

(on "#buttons" :click
    (fn [button]
      (set-mode (:id button))))
