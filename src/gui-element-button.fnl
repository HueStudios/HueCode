(local gui-element-rectangular (require :gui-element-rectangular))
(local gui-color-scheme (require :gui-color-scheme))
(defn gui-element-button [x y parent width height text]
  (var new-element (gui-element-rectangular x y parent width height))
  (tset new-element :mouse-over false)
  (defn new-element.draw []
    (love.graphics.push)
    (if (= new-element.mouse-over true)
      (gui-color-scheme.set-color :container 1)
      (gui-color-scheme.set-color :container 0.2))
    (love.graphics.rectangle :fill (new-element.get-global-x) (new-element.get-global-y) new-element.width new-element.height)
    (love.graphics.pop))
  (defn new-element.on-mouse-enter [x y]
    (tset new-element :mouse-over true))
  (defn new-element.on-mouse-leave [x y]
    (tset new-element :mouse-over false))
  new-element)
