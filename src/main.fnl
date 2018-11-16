(local gui-color-scheme (require :gui-color-scheme))
(local gui-manager (require :gui-manager))
(local gui-element-button (require :gui-element-button))
(local gui-element-view-relative (require :gui-element-view-relative))
(local gui-element-node-core (require :gui-element-node-core))
(local gui-element-text-input (require :gui-element-text-input))

(defn love.load []
  (gui-manager.initialize)
  (local view (gui-element-view-relative 20 20 nil 500 500))
  ;(gui-element-button 20 20 view 200 40 "This is a test")
  ;(gui-element-button 220 20 view 200 40 "Hue")
  (gui-element-node-core 200 200 nil)
  (gui-element-text-input 100 300 nil 240 "This is the input caption"))
(defn love.update [dt]
  (gui-manager.update dt))

(defn love.draw []
  (love.graphics.clear gui-color-scheme.background-color.r gui-color-scheme.background-color.g gui-color-scheme.background-color.b)
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
