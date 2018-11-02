(local gui-element (require :gui-element))
(defn gui-element-rectangular [x y parent width height]
  (var new-element (gui-element x y parent))
  (set new-element.width width)
  (defn new-element.get-width []
    new-element.width)
  (set new-element.height height)
  (defn new-element.get-height []
    new-element.height)
  (defn new-element.is-inside? [x y]
    (var inside false)
    (var min-x (new-element.get-global-x))
    (var min-y (new-element.get-global-y))
    (var max-x (+ min-x (new-element.get-width)))
    (var max-y (+ min-y (new-element.get-height)))
    (when (and (< x max-x) (< y max-y) (> x min-x) (> y min-y))
      (set inside true))
    inside)
  new-element)
