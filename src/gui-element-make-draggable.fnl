(defn gui-element-make-draggable [new-element]
  (tset new-element :drag-point-x 0)
  (tset new-element :drag-point-y 0)
  (tset new-element :previous-x 0)
  (tset new-element :previous-y 0)
  (local temporal-on-mouse-down new-element.on-mouse-down)
  (defn new-element.on-mouse-down [x y button]
    (temporal-on-mouse-down x y button)
    (when (= button 1)
      (tset new-element :drag-point-x x)
      (tset new-element :drag-point-y y)
      (tset new-element :dragging true)))
  (local temporal-on-mouse-global-up new-element.on-mouse-global-up)
  (defn new-element.on-mouse-global-up [x y button local-x local-y]
    (temporal-on-mouse-global-up x y button)
    (when (= button 1)
      (tset new-element :dragging false)))
  (local temporal-on-mouse-drag new-element.on-mouse-drag)
  (defn new-element.on-mouse-global-drag [a b button x y]
    (temporal-on-mouse-drag x y button)
    (when (and (= button 1) new-element.dragging)
      (set new-element.x (+ new-element.x x (- 0 new-element.drag-point-x)))
      (set new-element.y (+ new-element.y y (- 0 new-element.drag-point-y))))))
