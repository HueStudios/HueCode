(local gui-element (require :gui-element))
(defn gui-element-rectangular [x y parent width height]
  (var new-element (gui-element x y parent))
  (set new-element.width width)
  (set new-element.height height)
  (defn new-element.is-inside? [x y]
    (var inside false)
    (var min-x (new-element.get-global-x))
    (var min-y (new-element.get-global-y))
    (var max-x (+ min-x width))
    (var max-y (+ min-y height))
    (when (and (< x max-x) (< y max-y) (> x min-x) (> x max-x))
      (set inside true))
    inside))
