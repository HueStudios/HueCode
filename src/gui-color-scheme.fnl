(local gui-color-scheme {})
(tset gui-color-scheme :background-color
  {:r (/ 38 255) :g (/ 38 255) :b (/ 38 255)})
(tset gui-color-scheme :container
  {:r (/ 43 255) :g (/ 43 255) :b (/ 43 255)})
(tset gui-color-scheme :top-element
  {:r (/ 56 255) :g (/ 56 255) :b (/ 56 255)})
(tset gui-color-scheme :top-element-hover
  {:r (/ 60 255) :g (/ 60 255) :b (/ 60 255)})
(tset gui-color-scheme :top-element-click
  {:r (/ 99 255) :g (/ 99 255) :b (/ 99 255)})
(tset gui-color-scheme :text
  {:r (/ 207 255) :g (/ 207 255) :b (/ 207 255)})
(tset gui-color-scheme :ui-active
  {:r (/ 66 255) :g (/ 168 255) :b (/ 150 255)})
(defn gui-color-scheme.set-color [name alpha]
  (when (= alpha nil)
    (var alpha 1))
  (if (. gui-color-scheme name)
    (do
      (local r (. gui-color-scheme name :r))
      (local g (. gui-color-scheme name :g))
      (local b (. gui-color-scheme name :b))
      (love.graphics.setColor r g b alpha))
    (print (.. "The color " name " does not exist in the color scheme"))))
gui-color-scheme
