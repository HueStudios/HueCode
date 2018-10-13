(local color-scheme (require :color-scheme))

(defn love.load [])

(defn love.update [dt])

(defn love.draw []
  (love.graphics.clear color-scheme.background-color.r color-scheme.background-color.g color-scheme.background-color.b))

nil
