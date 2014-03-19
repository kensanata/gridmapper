(ns gridmapper.core
  (:import (javax.swing JLabel JPanel JFrame ImageIcon)
	   (javax.swing.event MouseInputAdapter)
	   (java.awt GridBagLayout GridBagConstraints)
	   (java.awt.event KeyAdapter InputEvent))
  (:gen-class))

(def EMPTY_TILE (ImageIcon. (clojure.java.io/resource "empty.png")))
(def FLOOR_TILE (ImageIcon. (clojure.java.io/resource "floor.png")))
(def TRAP_TILE  (ImageIcon. (clojure.java.io/resource "trap.png")))
;; virtual tiles and their equivalents
(def DOOR_TILE #'DOOR_TILE)
(def DOOR_NS_TILE (ImageIcon. (clojure.java.io/resource "door_ns.png")))
(def DOOR_EW_TILE (ImageIcon. (clojure.java.io/resource "door_ew.png")))

(def cell-positions (atom {}))

(defstruct cell-struct :x :y)

(defn cell-pos [cell]
  (get @cell-positions cell))

(defn find-cell [x y]
  (loop [keys (keys @cell-positions)]
    (let [key (first keys)]
      (cond (not key)
	    nil
	    (and (= (get (cell-pos key) :x) x)
		 (= (get (cell-pos key) :y) y))
	    key
	    true
	    (recur (rest keys))))))

(defn north [cell]
  (let [pos (cell-pos cell)]
    (when pos
      (find-cell (get pos :x) (- (get pos :y) 1)))))

(defn east [cell]
  (let [pos (cell-pos cell)]
    (when pos
      (find-cell (+ (get pos :x) 1) (get pos :y)))))

(defn south [cell]
  (let [pos (cell-pos cell)]
    (when pos
      (find-cell (get pos :x) (+ (get pos :y) 1)))))

(defn west [cell]
  (let [pos (cell-pos cell)]
    (when pos
      (find-cell (- (get pos :x) 1) (get pos :y)))))

(defn get-door-tile [cell]
  (let [north (north cell)
	east  (east cell)
	south (south cell)
	west  (west cell)]
    (cond (and (or (not north) (.equals (.getIcon north) EMPTY_TILE))
	       (or (not south) (.equals (.getIcon south) EMPTY_TILE))
	       (and east (.equals (.getIcon east)  FLOOR_TILE))
	       (and west (.equals (.getIcon cell)  FLOOR_TILE)))
	  DOOR_EW_TILE
	  (and (and north (.equals (.getIcon north) FLOOR_TILE))
	       (and south (.equals (.getIcon south) FLOOR_TILE))
	       (or (not east) (.equals (.getIcon east)  EMPTY_TILE))
	       (or (not west) (.equals (.getIcon west)  EMPTY_TILE)))
	  DOOR_NS_TILE
	  true
	  FLOOR_TILE)))

(def current-tile (atom FLOOR_TILE))
  
(defn get-tile [cell]
  "Return the tile the user wants to place.
By default this will be a FLOOR_TILE. If the current tile
is a virtual tile such as DOOR_TILE, it will investigate
the neighbours of CELL to figure out whether to return
DOOR_NS_TILE or DOOR_EW_TILE. CELL must be a JLabel belonging
to a JPanel controlled by a GridBagLayout."
  (let [tile @current-tile]
    (cond (.equals tile DOOR_TILE)
	  (get-door-tile cell)
	  true
	  tile)))

(defn set-tile [tile]
  "Set the tile the user wants to place.
This must be an ImageIcon."
  (reset! current-tile tile))
  
(defn edit-grid [e]
  "Draw a tile at the position of the event E.

from       to
EMPTY      FLOOR
FLOOR      EMPTY if already FLOOR
FLOOR      current tile
any tile   FLOOR"
  (let [cell (.getComponent e)
	here (.getIcon cell)
	tile (get-tile cell)]
    (cond (.equals here EMPTY_TILE)
	  (.setIcon cell FLOOR_TILE)
	  (and (.equals here FLOOR_TILE)
	       (.equals tile FLOOR_TILE))
	  (.setIcon cell EMPTY_TILE)
	  (.equals here FLOOR_TILE)
	  (.setIcon cell tile)
	  true
	  (.setIcon cell FLOOR_TILE))))

(defn mouse-input-adapter []
  "A MouseInputAdapter that will call EDIT-GRID when the mouse is clicked
or dragged into a grid cell."
  (proxy [MouseInputAdapter] []
    (mousePressed [e]
      (edit-grid e))
    (mouseEntered [e]
      (let [mask InputEvent/BUTTON1_DOWN_MASK]
	(if (= mask (bit-and mask (.getModifiersEx e)))
	  (edit-grid e))))))

(let [mouse (mouse-input-adapter)]
  ;; share the mouse input adapter with every other tile
  (defn empty-tile []
    (doto (JLabel. EMPTY_TILE)
      (.addMouseListener mouse)
      (.addMouseMotionListener mouse))))

(defn keyboard-adapter []
  (proxy [KeyAdapter] []
    (keyTyped [e]
       (let [c (.getKeyChar e)]
	 (condp = c
	     \d (set-tile DOOR_TILE)
	     \t (set-tile TRAP_TILE)
	     \n (set-tile FLOOR_TILE)
	     true)))))

(defn simple-grid [panel width height]
  "Creates a grid of WIDTH columns and HEIGHT rows
where each cell contains the result of a call to (EMPTY-TILE)
and adds it to the PANEL. It also creates the MAP."
  (let [constraints (GridBagConstraints.)
	width (- width 1)
	height (- height 1)]
    (loop [x 0 y 0 map (hash-map)]
      (let [tile (empty-tile)]
	(set! (. constraints gridx) x)
	(set! (. constraints gridy) y)
	(. panel add tile constraints)
	(cond (and (= x width) (= y height))
	      (do (reset! cell-positions
			  (assoc map tile (struct cell-struct x y)))
		  panel)
	      (= y height)
	      (recur (+ x 1) 0
		     (assoc map tile (struct cell-struct x y)))
	      true
	      (recur x (+ y 1)
		     (assoc map tile (struct cell-struct x y))))))))

(defn -main []
  (let [frame (JFrame. "Grid Mapper")
	panel (doto (JPanel. (GridBagLayout.))
		(simple-grid 30 30))]
    (doto frame
      (.addKeyListener (keyboard-adapter))
      (.setContentPane panel)
      (.pack)
      (.setDefaultCloseOperation JFrame/EXIT_ON_CLOSE)
      (.setVisible true))))
