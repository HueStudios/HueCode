(local gui-element-circular (require :gui-element-circular))
(local gui-color-scheme (require :gui-color-scheme))
(local gui-element-make-interactable (require :gui-element-make-interactable))
(local gui-element-make-draggable (require :gui-element-make-draggable))
(defn gui-element-node-core [x y parent]
  (var new-element (gui-element-circular x y parent 15 0))
  (gui-element-make-interactable new-element)
  (gui-element-make-draggable new-element)
  (defn new-element.prev-draw []
    (gui-color-scheme.set-color :text)
    (love.graphics.circle :fill (new-element.get-global-x) (new-element.get-global-y) 3))
  (defn new-element.over-draw []
    (gui-color-scheme.set-color :text)
    (love.graphics.circle :fill (new-element.get-global-x) (new-element.get-global-y) 6))
  (defn new-element.down-draw []
    (gui-color-scheme.set-color :text)
    (love.graphics.circle :fill (new-element.get-global-x) (new-element.get-global-y) 9))
  (defn new-element.post-draw [])
  new-element)
