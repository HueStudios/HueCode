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
    (when (not mouse-captured)
      (when (b.is-inside? mouse-x mouse-y)
        (set mouse-captured b)
        (b.on-mouse-wheel
          (- mouse-x (b.get-global-x))
          (- mouse-y (b.get-global-y))
          dx dy)))
    (b.on-global-mouse-wheel mouse-x mouse-y dx dy)))

(defn gui-manager-events.handle-key-pressed [elements key code repeat]
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (b.on-key-pressed-global key code repeat)))

(defn gui-manager-events.handle-key-released [elements key code repeat]
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (b.on-key-released-global key code repeat)))

(defn gui-manager-events.handle-text-input [elements text]
  (each [k v (ipairs elements)]
    (var s (+ 1 (- (# elements) k)))
    (var b (. elements s))
    (b.on-text-input-global key code repeat)))

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
    (when (not mouse-captured)
      (when (b.is-inside? mouse-x mouse-y)
        (set mouse-captured b)
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
            (set previous-mouse-over b)))))
    (each [i n (ipairs mouse-buttons)]
      (when (and (. previous-mouse-buttons i) n)
        (b.on-mouse-global-drag mouse-x mouse-y n)
        (when (= b mouse-captured)
          (b.on-mouse-drag
            (- mouse-x (b.get-global-x))
            (- mouse-y (b.get-global-y))
            n)))
      (when (and (. previous-mouse-buttons i) (not n))
        (b.on-mouse-global-up mouse-x mouse-y n)
        (when (= b mouse-captured)
          (b.on-mouse-up
            (- mouse-x (b.get-global-x))
            (- mouse-y (b.get-global-y))
            n)))
      (when (and (not (. previous-mouse-buttons i)) n)
        (b.on-mouse-global-down mouse-x mouse-y n)
        (when (= b mouse-captured)
          (b.on-mouse-down
            (- mouse-x (b.get-global-x))
            (- mouse-y (b.get-global-y))))))
    (when previous-mouse-over
      (when (not (previous-mouse-over.is-inside?))
        (previous-mouse-over.on-mouse-leave
          (- mouse-x (previous-mouse-over.get-global-x))
          (- mouse-y (previous-mouse-over.get-global-y)))))
    (set previous-mouse-buttons mouse-buttons)))

gui-manager-events
