(local gui-element-circular (require :gui-element-circular))
(defn gui-element-rectangular [x y parent radius inner-radius a-rads b-rads]
  (var new-element (gui-element-circular x y parent radius inner-radius))
  (set new-element.radius radius)
  (defn new-element.get-radius []
    new-element.radius)
  (set new-element.inner-radius inner-radius)
  (defn new-element.get-inner-radius []
    new-element.radius)
  (set new-element.a-rads a-rads)
  (defn new-element.get-a-rads []
    new-element.a-rads)
  (set new-element.b-rads b-rads)
  (defn new-element.get-b-rads []
    new-element.b-rads)
  (local inherited-is-inside? new-element.is-inside?)
  (defn new-is-inside? [x y]
    (var inside false)
    (var inside-circle (inherited-is-inside? x y))
    (when inside-circle
      (local new-x (/ (- 0 (- (new-element.get-global-x) x)) new-element.radius))
      (local new-y (/ (- (new-element.get-global-y) y) new-element.radius))
      (var radians (math.atan2 new-y new-x))
      (when (< radians 0)
        (set radians (+ radians (* math.pi 2))))
      (local mod-a (% new-element.a-rads))
      (local rotation (- radians mod-a))
      (set inside (< rotation b-rads)))
    inside)
  (tset new-element :is-inside? new-is-inside?)
  new-element)
