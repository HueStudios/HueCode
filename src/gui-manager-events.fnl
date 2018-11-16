(local gui-manager-events {})
(var previous-mouse-buttons {1 false 2 false 3 false})
(var previous-mouse-over nil)

(defn gui-manager-events.handle-wheel [elements dx dy]
  (var mouse-captured nil)
  (local mouse-x (love.mouse.getX))
  (local mouse-y (love.mouse.getY))
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (when b.enabled
      (when (not mouse-captured)
        (when (b.is-inside? mouse-x mouse-y)
          (set mouse-captured b)
          (b.on-mouse-wheel
            (- mouse-x (b.get-global-x))
            (- mouse-y (b.get-global-y))
            dx dy)))
      (b.on-mouse-global-wheel mouse-x mouse-y dx dy))))

(defn gui-manager-events.handle-key-pressed [elements key code repeat]
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (when b.enabled
      (b.on-key-pressed-global key code repeat))))

(defn gui-manager-events.handle-key-released [elements key code repeat]
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (when b.enabled
      (b.on-key-released-global key code repeat))))

(defn gui-manager-events.handle-text-input [elements text]
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (when b.enabled
      (b.on-text-input-global text))))

(defn gui-manager-events.handle-events [elements]
  (var mouse-captured nil)
  (var mouse-buttons {})
  (for [mouse-button 1 3]
    (if (love.mouse.isDown mouse-button)
      (tset mouse-buttons mouse-button true)
      (tset mouse-buttons mouse-button false)))
  (local mouse-x (love.mouse.getX))
  (local mouse-y (love.mouse.getY))
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (when b.enabled
      (when (not mouse-captured)
        (when (b.is-inside? mouse-x mouse-y)
          (when b
            (set mouse-captured b))
          (if (= previous-mouse-over b)
            (b.on-mouse-hover
              (- mouse-x (b.get-global-x))
              (- mouse-y (b.get-global-y)))
            (do
              (when previous-mouse-over
                (previous-mouse-over.on-mouse-leave
                  (- mouse-x (previous-mouse-over.get-global-x))
                  (- mouse-y (previous-mouse-over.get-global-y))))
              (b.on-mouse-enter
                (- mouse-x (b.get-global-x))
                (- mouse-y (b.get-global-y)))
              (set previous-mouse-over b)))))))
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (when b.enabled
      (each [i n (ipairs mouse-buttons)]
        (local previous-button (. previous-mouse-buttons i))
        (when (and (not previous-button) n)
          (b.on-mouse-global-down
            mouse-x
            mouse-y
            i
            (- mouse-x (b.get-global-x))
            (- mouse-y (b.get-global-y))
            (= b mouse-captured))
          (when (= b mouse-captured)
            (b.on-mouse-down
              (- mouse-x (b.get-global-x))
              (- mouse-y (b.get-global-y))
              i)))
        (when (and previous-button n)
          (b.on-mouse-global-drag
            mouse-x
            mouse-y
            i
            (- mouse-x (b.get-global-x))
            (- mouse-y (b.get-global-y))
            (= b mouse-captured))
          (when (= b mouse-captured)
            (b.on-mouse-drag
              (- mouse-x (b.get-global-x))
              (- mouse-y (b.get-global-y))
              i)))
        (when (and previous-button (not n))
          (b.on-mouse-global-up
            mouse-x
            mouse-y
            i
            (- mouse-x (b.get-global-x))
            (- mouse-y (b.get-global-y))
            (= b mouse-captured))
          (when (= b mouse-captured)
            (b.on-mouse-up
              (- mouse-x (b.get-global-x))
              (- mouse-y (b.get-global-y))
              i))))))
  (when previous-mouse-over
    (when (not (previous-mouse-over.is-inside? mouse-x mouse-y))
      (previous-mouse-over.on-mouse-leave
        (- mouse-x (previous-mouse-over.get-global-x))
        (- mouse-y (previous-mouse-over.get-global-y)))
      (set previous-mouse-over nil)))
  (for [mouse-button 1 3]
    (tset previous-mouse-buttons mouse-button (. mouse-buttons mouse-button))))

gui-manager-events
