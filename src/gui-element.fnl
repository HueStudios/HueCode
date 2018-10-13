(local gui-manager (require :gui-manager))
(defn gui-element [x y parent]
  (local new-element {:x x :y y :depth (+ 1 parent.depth :parent parent :children {} :width 0 :height 0)})
  (tset parent.children (+ 1 (# parent.children)) new-element)
  (defn new-element.get-global-x []
    (+ (new-element-parent.get-global-x) new-element.x))
  (defn new-element.get-global-y []
    (+ (new-element-parent.get-global-y) new-element.y))
  (defn new-element.load [])
  (defn new-element.update [dt])
  (defn new-element.draw [])
  (gui-manager.register-element new-element)
  new-element)
