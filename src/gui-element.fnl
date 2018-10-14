(local gui-manager (require :gui-manager))

(defn gui-element [x y parent]
  (local new-element {:x x :y y :depth (+ 1 (or parent.depth 0) :parent parent :children {})})
  (defn new-element.get-global-x []
    new-element.x)
  (defn new-element.get-global-y []
    new-element.y)
  (when parent
    (tset parent.children (+ 1 (# parent.children)) new-element)
    (defn new-element.get-global-x []
      (+ (new-element.parent.get-global-x) new-element.x))
    (defn new-element.get-global-y []
      (+ (new-element.parent.get-global-y) new-element.y)))
  (defn new-element.is-inside? [x y]
    false)
  (defn new-element.load [])
  (defn new-element.update [dt])
  (defn new-element.draw [])
  (defn new-element.on-mouse-enter [x y])
  (defn new-element.on-mouse-leave [x y])
  (defn new-element.on-mouse-down [x y])
  (defn new-element.on-mouse-global-down [x y])
  (defn new-element.on-mouse-up [x y])
  (defn new-element.on-mouse-global-up [x y])
  (defn new-element.on-mouse-drag [x y])
  (defn new-element.on-mouse-global-drag [x y])
  (defn new-element.on-mouse-wheel [x y dx dy])
  (defn new-element.on-mouse-global-wheel [x y dx dy])
  (defn new-element.on-key-pressed-global [key code repeat])
  (defn new-element.on-key-released-global [key code repeat])
  (defn new-element.on-text-input [text])
  (gui-manager.register-element new-element)
  new-element)
