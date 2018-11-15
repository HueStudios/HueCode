(local gui-element-circular (require :gui-element-circular))
(local gui-color-scheme (require :gui-color-scheme))
(local gui-element-make-interactable (require :gui-element-make-interactable))
(local gui-element-make-draggable (require :gui-element-make-draggable))
(local gui-element-make-selectable (require :gui-element-make-selectable))
(defn gui-element-node-core [x y parent]
  (var new-element (gui-element-circular x y parent 15 0))
  (gui-element-make-draggable new-element)
  (defn new-element.draw []
    (gui-color-scheme.set-color :text)
    (love.graphics.circle :fill (new-element.get-global-x) (new-element.get-global-y) 3))
  (gui-element-make-interactable new-element)
  (defn new-element.over-draw []
    (gui-color-scheme.set-color :text)
    (love.graphics.circle :fill (new-element.get-global-x) (new-element.get-global-y) 6))
  (defn new-element.down-draw []
    (gui-color-scheme.set-color :text)
    (love.graphics.circle :fill (new-element.get-global-x) (new-element.get-global-y) 9))
  (gui-element-make-selectable new-element)
  (defn new-element.selected-draw []
    (gui-color-scheme.set-color :text)
    (love.graphics.circle :line (new-element.get-global-x) (new-element.get-global-y) 50 45))
  new-element)
