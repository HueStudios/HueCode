(local gui-element-rectangular (require :gui-element-rectangular))
(local color-scheme (require :color-scheme))
(defn gui-element-button [x y parent width height text]
  (var new-element (gui-element-rectangular x y parent width height))
  (defn new-element.draw []
    (love.graphics.push)
    (love.graphics.setColor color-scheme.container.r color-scheme.container.g color-scheme.container.b 1)
    (love.graphics.rectangle :fill (new-element.get-global-x) (new-element.get-global-y) new-element.width new-element.height)
    (love.graphics.pop))
  new-element)
