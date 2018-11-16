(local gui-manager (require :gui-manager))

(defn gui-element [x y parent]
  (local new-element {:x x :y y :depth 1 :parent parent :children {} :enabled true})
  (defn new-element.get-global-x []
    new-element.x)
  (defn new-element.get-global-y []
    new-element.y)
  (when parent
    (tset new-element new-element.depth (+ 1 parent.depth))
    (tset parent.children (+ 1 (# parent.children)) new-element)
    (defn new-element.get-global-x []
      (+ (new-element.parent.get-global-x) new-element.x))
    (defn new-element.get-global-y []
      (+ (new-element.parent.get-global-y) new-element.y))
    (parent.on-new-children new-element))
  (defn new-element.is-inside? [x y]
    false)
  (defn recursive-children-lookup [target current]
    (when (> (# target.children) 0)
      (each [k v (pairs target.children)]
        (tset current (+ 1 (# current)) v)
        (recursive-children-lookup v current)))
    current)
  (defn new-element.toggle []
    (var disabled false)
    (when new-element.enabled
      (set disabled true))
    (set new-element.enabled (not new-element.enabled))
    (local all-children {})
    (recursive-children-lookup new-element all-children)
    (each [k v (pairs all-children)]
      (if disabled
        (do
          (set v.temp-enabled v.enabled)
          (set v.enabled false))
        (do
          (if v.temp-enabled
            (do
              (set v.enabled v.temp-enabled)
              (set v.temp-enabled nil))
            (set v.enabled true))))))
  (defn new-element.on-new-children [children])
  (defn new-element.load [])
  (defn new-element.update [dt])
  (defn new-element.draw [])
  (defn new-element.on-mouse-enter [x y])
  (defn new-element.on-mouse-leave [x y])
  (defn new-element.on-mouse-hover [x y])
  (defn new-element.on-mouse-down [x y button])
  (defn new-element.on-mouse-global-down [x y button local-x local-y inside])
  (defn new-element.on-mouse-up [x y button])
  (defn new-element.on-mouse-global-up [x y button local-x local-y inside])
  (defn new-element.on-mouse-drag [x y button])
  (defn new-element.on-mouse-global-drag [x y button local-x local-y inside])
  (defn new-element.on-mouse-wheel [x y dx dy])
  (defn new-element.on-mouse-global-wheel [x y dx dy])
  (defn new-element.on-key-pressed-global [key code repeat])
  (defn new-element.on-key-released-global [key code repeat])
  (defn new-element.on-text-input-global [text])
  (gui-manager.register-element new-element)
  new-element)
