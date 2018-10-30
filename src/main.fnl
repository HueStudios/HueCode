(local color-scheme (require :color-scheme))
(local gui-manager (require :gui-manager))
(local gui-element-button (require :gui-element-button))

(defn love.load []
  (gui-element-button 20 20 nil 200 40 "Hue")
  (gui-element-button 220 20 nil 200 40 "Hue"))

(defn love.update [dt]
  (gui-manager.update dt))

(defn love.draw []
  (love.graphics.clear color-scheme.background-color.r color-scheme.background-color.g color-scheme.background-color.b)
  (gui-manager.draw))

(defn love.keypressed [key scancode repeat]
  (gui-manager.capture-keyboard-events :pressed key scancode repeat))

(defn love.keyreleased [key scancode repeat]
  (gui-manager.capture-keyboard-events :released key scancode repeat))

(defn love.wheelmoved [dx dy]
  (gui-manager.capture-mouse-wheel dx dy))

(defn love.textinput [text]
  (gui-manager.capture-text-input text))

nil
