(local gui-manager {})
(var elements {})
(var max-depth 1)
(var min-depth 1)
(defn gui-manager.register-element [to-register]
  (tset to-register :initialized false)
  (var out-of-bounds false)
  (print to-register.depth max-depth)
  (when (>= to-register.depth max-depth)
    (set out-of-bounds true)
    (set max-depth to-register.depth)
    (tset elements (+ 1 (# elements)) to-register))
  (when (< to-register.depth min-depth)
    (set out-of-bounds true)
    (set min-depth to-register.depth)
    (local new-elements {})
    (tset new-elements 1 to-register)
    (each [k v (ipairs elements)]
      (tset new-elements (+ 1 (# elements)) v))
    (set elements new-elements))
  (when (not out-of-bounds)
    (local new-elements {})
    (each [k v (ipairs elements)]
      (local next-depth (. (. elements (+ k 1) depth)))
      (when (and (= v.depth to-register.depth) (> next-depth to-register.depth))
        (tset new-elements (+ 1 (# elements)) to-register))
      (tset new-elements (+ 1 (# elements)) v))
    (set elements new-elements)))

(var previous-mouse-buttons {1 false 2 false 3 false})
(var previous-mouse-over nil)
(defn gui-manager.update [dt]
  (var mouse-captured nil)
  (var mouse-buttons {})
  (for [mouse-button 1 3]
    (if (love.mouse.isDown mouse-button)
      (tset mouse-buttons mouse-button true)
      (tset mouse-buttons mouse-button false)))
  (local mouse-x (love.mouse.getX))
  (local mouse-y (love.mouse.getY))
  (each [k v (ipairs elements)]
    (when (not v.initialized)
      (v.load)
      (tset v :initialized true))
    (v.update dt)

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

(defn gui-manager.draw []
  (each [k v (ipairs elements)]
    (v.draw)))

gui-manager
