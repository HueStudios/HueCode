(local gui-element-rectangular (require :gui-element-rectangular))
(local gui-element-label (require :gui-element-label))
(local gui-color-scheme (require :gui-color-scheme))
(local gui-element-make-interactable (require :gui-element-make-interactable))
(local gui-element-view-relative (require :gui-element-view-relative))
(local gui-element-make-selectable (require :gui-element-make-selectable))
(defn gui-element-text-input [x y parent width caption]
  (var new-element (gui-element-rectangular x y parent width 40))
  (gui-element-make-interactable new-element)
  (tset new-element :inner-view
    (gui-element-view-relative 3 3 new-element
      (- new-element.width 6)
      (- (+ new-element.height (new-element.get-global-y)) 6)))
  (defn new-element.inner-view.is-inside? [])
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
  (gui-element-make-selectable new-element)
  (defn new-element.draw-text-input-bar []
    (love.graphics.rectangle :fill
      (+ 3 (new-element.get-global-x))
      (- (+ new-element.height (new-element.get-global-y)) 5)
      (- new-element.width 6)
      2))
  (defn new-element.selected-draw []
    (gui-color-scheme.set-color :ui-active)
    (new-element.draw-text-input-bar))
  (defn new-element.unselected-draw []
    (gui-color-scheme.set-color :top-element-click)
    (new-element.draw-text-input-bar))
  new-element)
