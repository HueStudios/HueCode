(defn gui-element-make-selectable [new-element]
  (tset new-element :selected false)
  (local temp-global-down new-element.on-mouse-global-down)
  (defn new-element.on-mouse-global-down [x y button local-x local-y inside]
    (temp-global-down x y button local-x local-y inside)
    (when (= button 1)
      (tset new-element :selected inside)))
  (defn new-element.selected-draw [])
  (defn new-element.unselected-draw [])
  (local temp-draw new-element.draw)
  (defn new-element.draw []
    (temp-draw)
    (if (= new-element.selected true)
      (new-element.selected-draw)
      (new-element.unselected-draw))))
