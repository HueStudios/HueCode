(local gui-element-rectangular (require :gui-element-rectangular))
(defn gui-element-button [x y parent width height]
  (var new-element (gui-element-rectangular x y parent width height))
  (tset new-element :dirty-view true)
  (defn new-element.view-stencil-function []
    (love.graphics.rectangle :fill
      (new-element.get-global-x)
      (new-element.get-global-y)
      (new-element.get-width)
      (new-element.get-height)))
  (defn new-element.on-new-children [children]
    (tset new-element :dirty-view true))
  (defn decorate-child [child]
    (print child))
  (defn new-element.update [dt]
    (when new-element.dirty-view
      (tset new-element :dirty-view false)
      (defn recursive-children-lookup [target current]
        (when (> (# target.children) 0)
          (each [k v (pairs target.children)]
            (tset current (+ 1 (# current)) v)
            (recursive-children-lookup v current)))
        current)
      (local all-children {})
      (recursive-children-lookup new-element all-children)
      (each [k v (pairs all-children)]
        (if all-children.decorated
          (do
            (var decorated-by-view false)
            (each [j b (pairs all-children.decorated)]
              (when (= b new-element)
                (set decorated-by-view true)))
            (when (not decorated-by-view)
                (decorate-child v)
                (tset v.decorated (+ 1 (# v.decorated)) new-element)))
          (do
            (tset v :decorated {})
            (tset v.decorated 1 new-element))))))
  new-element)
