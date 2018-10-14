(local color-scheme (require :color-scheme))
(local gui-manager (require :gui-manager))

(defn love.load [])

(defn love.update [dt]
  (gui-manager.update dt))

(defn love.draw []
  (love.graphics.clear color-scheme.background-color.r color-scheme.background-color.g color-scheme.background-color.b)
  (gui-manager.draw))

nil
