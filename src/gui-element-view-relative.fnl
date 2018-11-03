(local gui-element-rectangular (require :gui-element-rectangular))
(defn gui-element-button [x y parent width height]
  (var new-element (gui-element-rectangular x y parent width height))
  (tset new-element :dirty-view true)
  (defn view-stencil-function []
    (love.graphics.rectangle :fill
      (new-element.get-global-x)
      (new-element.get-global-y)
      (new-element.get-width)
      (new-element.get-height)))
  (defn empty-stencil [])
  (defn new-element.on-new-children [children]
    (tset new-element :dirty-view true))
  (defn decorate-child [child]
    (local temporal-draw child.draw)
    (defn new-draw []
      (love.graphics.stencil view-stencil-function :increment 1 true)
      (love.graphics.setStencilTest :greater 0)
      (temporal-draw)
      (love.graphics.setStencilTest)
      (love.graphics.stencil empty-stencil :replace 0 false))
    (tset child :draw new-draw)
    (local temporal-is-inside? child.is-inside?)
    (defn new-is-inside? [x y]
      (local inside-element (temporal-is-inside? x y))
      (local inside-view (new-element.is-inside? x y))
      (local inside-both (and inside-element inside-view))
      inside-both)
    (tset child :is-inside? new-is-inside?)
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
            (decorate-child v)
            (tset v :decorated {})
            (tset v.decorated 1 new-element))))))
  new-element)
