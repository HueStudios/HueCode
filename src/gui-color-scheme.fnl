(local gui-color-scheme {})
(tset gui-color-scheme :background-color {:r (/ 36 255) :g (/ 36 255) :b (/ 36 255)})
(tset gui-color-scheme :container        {:r (/ 79 255) :g (/ 79 255) :b (/ 79 255)})
(defn gui-color-scheme.set-color [name alpha]
  (if (. gui-color-scheme name)
    (do
      (local r (. gui-color-scheme name :r))
      (local g (. gui-color-scheme name :g))
      (local b (. gui-color-scheme name :b))
      (love.graphics.setColor r g b alpha))
    (print (.. "The color " name " does not exist in the color scheme"))))
gui-color-scheme
