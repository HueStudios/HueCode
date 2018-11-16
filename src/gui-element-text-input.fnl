(local gui-element-rectangular (require :gui-element-rectangular))
(local gui-element-label (require :gui-element-label))
(local gui-color-scheme (require :gui-color-scheme))
(local gui-element-make-interactable (require :gui-element-make-interactable))
(local gui-element-view-relative (require :gui-element-view-relative))
(local gui-element-make-selectable (require :gui-element-make-selectable))
(local utf-8 (require :utf8))
(defn gui-element-text-input [x y parent width caption]
  (var new-element (gui-element-rectangular x y parent width 40))
  (gui-element-make-interactable new-element)
  (tset new-element :inner-view
    (gui-element-view-relative
      7 5 new-element
      (- new-element.width 14)
      (- new-element.height 11)))
  (tset new-element :text "")
  (tset new-element :text-label
    (gui-element-label
      0 0 new-element.inner-view
      new-element.inner-view.width
      new-element.inner-view.height
      new-element.text
      :left))
  (tset new-element :caption :text)
  (when caption
    (tset new-element :caption caption))
  (tset new-element :caption-label
    (gui-element-label
      7 5 new-element
      (- new-element.width 14)
      (- new-element.height 11)
      new-element.caption
      :left))
  (tset new-element.caption-label :color :top-element-click)
  (defn new-element.inner-view.is-inside? [])
  (defn new-element.idle-draw []
    (gui-color-scheme.set-color :top-element))
  (defn new-element.down-draw []
    (gui-color-scheme.set-color :top-element-click))
  (defn new-element.over-draw []
    (gui-color-scheme.set-color :top-element-hover))
  (local temp-draw new-element.draw)
  (defn new-element.draw []
    (temp-draw)
    (love.graphics.rectangle :fill
      (new-element.get-global-x)
      (new-element.get-global-y)
      (new-element.get-width)
      (new-element.get-height))
    (tset new-element.caption-label :enabled (= (# new-element.text) 0))
    (tset new-element.text-label :enabled (not (= (# new-element.text) 0))))
  (gui-element-make-selectable new-element)
  (defn new-element.on-select []
    (love.keyboard.setTextInput true))
  (defn new-element.on-unselect []
    (love.keyboard.setTextInput false))
  (defn new-element.on-text-input-global [text]
    (when new-element.selected
      (set new-element.text (.. new-element.text text))
      (set new-element.text-label.text new-element.text)))
  (defn new-element.on-key-pressed-global [key code repeat]
    (when (and new-element.selected (= key :backspace))
      (local byte-offset (utf-8.offset new-element.text -1))
      (when byte-offset
        (set new-element.text (string.sub new-element.text 1 (- byte-offset 1)))
        (set new-element.text-label.text new-element.text))))
  (defn new-element.draw-text-input-bar []
    (love.graphics.rectangle :fill
      (+ 3 (new-element.get-global-x))
      (- (+ new-element.height (new-element.get-global-y)) 5)
      (- new-element.width 6)
      2))
  (defn new-element.selected-draw []
    (gui-color-scheme.set-color :ui-active)
    (new-element.draw-text-input-bar))
  (defn new-element.unselected-draw []
    (gui-color-scheme.set-color :top-element-click)
    (new-element.draw-text-input-bar))
  new-element)
