(local gui-element-rectangular (require :gui-element-rectangular))
(local gui-element-label (require :gui-element-label))
(local gui-color-scheme (require :gui-color-scheme))
(local gui-element-make-interactable (require :gui-element-make-interactable))
(defn gui-element-button [x y parent width height text]
  (var new-element (gui-element-rectangular x y parent width height))
  (gui-element-make-interactable new-element)
  (when text
    (gui-element-label 0 0 new-element width height text :center))
  (defn new-element.draw []
    (if (= new-element.mouse-over false)
      (gui-color-scheme.set-color :top-element)
      (= new-element.mouse-hold true)
      (gui-color-scheme.set-color :top-element-click)
      (gui-color-scheme.set-color :top-element-hover))
    (love.graphics.rectangle :fill
      (new-element.get-global-x)
      (new-element.get-global-y)
      (new-element.get-width)
      (new-element.get-height)))
  new-element)
