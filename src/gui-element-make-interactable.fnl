(defn gui-element-make-interactable [new-element]
  (tset new-element :mouse-over false)
  (tset new-element :mouse-hold false)
  (local temp-enter new-element.on-mouse-enter)
  (local temp-leave new-element.on-mouse-leave)
  (local temp-down new-element.on-mouse-down)
  (local temp-global-up new-element.on-mouse-global-up)
  (defn new-element.on-mouse-enter [x y]
    (temp-enter x y)
    (tset new-element :mouse-over true))
  (defn new-element.on-mouse-leave [x y]
    (temp-leave x y)
    (tset new-element :mouse-over false))
  (defn new-element.on-mouse-down [x y button]
    (temp-down x y button)
    (when (= button 1)
      (tset new-element :mouse-hold true)))
  (defn new-element.on-mouse-global-up [x y button]
    (temp-global-up x y button)
    (when (= button 1)
      (tset new-element :mouse-hold false)))
  (defn new-element.prev-draw [])
  (defn new-element.idle-draw [])
  (defn new-element.over-draw [])
  (defn new-element.down-draw [])
  (defn new-element.post-draw [])
  (defn new-element.draw []
    (new-element.prev-draw)
    (if (= new-element.mouse-over false)
      (new-element.idle-draw)
      (= new-element.mouse-hold true)
      (new-element.down-draw)
      (new-element.over-draw))
    (new-element.post-draw)))
