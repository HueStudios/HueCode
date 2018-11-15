(local gui-element-rectangular (require :gui-element-rectangular))
(local gui-element-label (require :gui-element-label))
(local gui-color-scheme (require :gui-color-scheme))
(local gui-element-make-interactable (require :gui-element-make-interactable))
(local gui-element-view-relative (require :gui-element-view-relative))
(defn gui-element-text-input [x y parent width caption]
  (var new-element (gui-element-rectangular x y parent width 20))
  (gui-element-make-interactable new-element)
  (gui-element-view-relative [3 3 new-element (- width 6) 17])
  (defn new-element.idle-draw []
    (gui-color-scheme.set-color :top-element))
  (defn new-element.down-draw []
    (gui-color-scheme.set-color :top-element-click))
  (defn new-element.over-draw []
    (gui-color-scheme.set-color :top-element-hover))
  (local temp-draw new-element.draw)
  (defn new-element.draw []
    (temp-draw)
    (love.graphics.rectangle :fill
      (new-element.get-global-x)
      (new-element.get-global-y)
      (new-element.get-width)
      (new-element.get-height)))
  new-element)
