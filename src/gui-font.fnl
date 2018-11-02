(local gui-font {})
(defn gui-font.load-fonts []
  (tset gui-font :content
    (love.graphics.newFont "depends/NotoSans-Regular.ttf" 15))
  (tset gui-font :code
    (love.graphics.newFont "depends/NotoMono-Regular.ttf" 16)))
(defn gui-font.set-font [name]
  (if (. gui-font name)
    (do
      (local font (. gui-font name))
      (love.graphics.setFont font))
    (print (.. "The font " name " does not exist in the font database"))))
gui-font
