(local color-scheme (require :color-scheme))
(local gui-manager (require :gui-manager))
(local gui-element-button (require :gui-element-button))

(defn love.load []
  (gui-element-button 20 20 nil 200 40 "Hue"))

(defn love.update [dt]
  (gui-manager.update dt))

(defn love.draw []
  (love.graphics.clear color-scheme.background-color.r color-scheme.background-color.g color-scheme.background-color.b)
  (gui-manager.draw))

nil
