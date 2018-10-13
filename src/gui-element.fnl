(local gui-manager (require :gui-manager))
(defn gui-element [x y depth]
  (local new-element {:x x :y y :depth depth})
  (defn new-element.load [])
  (defn new-element.update [])
  (defn new-element.draw [])
  (gui-manager.register-element new-element)
  new-element)
