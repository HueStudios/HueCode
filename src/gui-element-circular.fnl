(local gui-element (require :gui-element))
(defn gui-element-rectangular [x y parent radius inner-radius]
  (var new-element (gui-element x y parent))
  (set new-element.radius radius)
  (defn new-element.get-radius []
    new-element.radius)
  (set new-element.inner-radius inner-radius)
  (defn new-element.get-inner-radius []
    new-element.radius)
  (defn new-element.is-inside? [x y]
    (var inside false)
    (local dxs (* (- new-element.x x) (- new-element.x x)))
    (local dys (* (- new-element.y y) (- new-element.x y)))
    (local distance (math.sqrt (+ dxs dys)))
    (set inside (and (< distance radius) (> distance inner-radius)))
    ;(print inner-radius distance radius inside)
    inside)
  new-element)
