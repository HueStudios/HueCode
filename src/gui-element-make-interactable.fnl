(defn gui-element-make-interactable [new-element]
  (tset new-element :mouse-over false)
  (tset new-element :mouse-hold false)
  (defn new-element.on-mouse-enter [x y]
    (tset new-element :mouse-over true))
  (defn new-element.on-mouse-leave [x y]
    (tset new-element :mouse-over false))
  (defn new-element.on-mouse-down [x y button]
    (when (= button 1)
      (tset new-element :mouse-hold true)))
  (defn new-element.on-mouse-global-up [x y button]
    (when (= button 1)
      (tset new-element :mouse-hold false))))
