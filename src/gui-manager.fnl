(local gui-manager {})
(var elements {})
(var max-depth 1)
(var min-depth 1)
(defn gui-manager.register-element [to-register]
  (tset to-register initialized false)
  (var out-of-bounds false)
  (when (> to-register.depth max-depth)
    (set out-of-bounds true)
    (set max-depth to-register.depth)
    (tset elements (+ 1 (# elements) to-register)))
  (when (< to-register.depth min-depth)
    (set out-of-bounds true)
    (set min-depth to-register.depth)
    (local new-elements {})
    (tset new-elements 1 to-register)
    (each [k v (ipairs elements)]
      (tset new-elements (+ 1 (# elements)) v))
    (set elements new-elements))
  (when (not out-of-bounds)
    (local new-elements {})
    (each [k v (ipairs elements)]
      (local next-depth (. (. elements (+ k 1) depth)))
      (when (and (= v.depth to-register.depth) (> previous-depth to-register.depth))
        (tset new-elements (+ 1 (# elements)) to-register))
      (tset new-elements (+ 1 (# elements)) v))
    (set elements new-elements)))

(defn gui-manager.update [dt]
  (each [k v (ipairs elements)]
    (when (not v.initialized)
      (v.load)
      (tset v initialized true))
    (v.update dt)))

(defn gui-manager.draw []
  (each [k v (ipairs elements)]
    (v.draw)))

gui-manager
