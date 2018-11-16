(local gui-manager {})
(local gui-manager-events (require :gui-manager-events))
(local gui-font (require :gui-font))
(var elements {})
(var max-depth 1)
(var min-depth 1)
(defn gui-manager.register-element [to-register]
  (tset to-register :initialized false)
  (var out-of-bounds false)
  (when (>= to-register.depth max-depth)
    (set out-of-bounds true)
    (set max-depth to-register.depth)
    (tset elements (+ 1 (# elements)) to-register))
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
      (when (and (= v.depth to-register.depth) (> next-depth to-register.depth))
        (tset new-elements (+ 1 (# elements)) to-register))
      (tset new-elements (+ 1 (# elements)) v))
    (set elements new-elements)))

(defn gui-manager.initialize []
  (gui-font.load-fonts))

(defn gui-manager.capture-keyboard-events [type key code repeat]
  (if (= type :press)
    (gui-manager-events.handle-key-pressed elements key code repeat)
    (gui-manager-events.handle-key-released elements key code repeat)))

(defn gui-manager.capture-text-input [text]
  (gui-manager-events.handle-text-input elements text))

(defn gui-manager.capture-mouse-wheel [dx dy]
  (gui-manager-events.handle-wheel dx dy))

(defn gui-manager.update [dt]
  (each [k v (ipairs elements)]
    (when v.enabled
      (when (not v.initialized)
        (v.load)
        (tset v :initialized true))
      (v.update dt)))
  (gui-manager-events.handle-events elements))


(defn gui-manager.draw []
  (each [k v (ipairs elements)]
    (when v.enabled
      (love.graphics.push)
      (v.draw)
      (love.graphics.pop))))

gui-manager
