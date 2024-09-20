import { Hook, makeHook } from "phoenix_typed_hook";

class OnMouseUpHook extends Hook {
  mounted() {
    this.el.addEventListener("mouseup", (e) => {
      console.log("ON MOUSE UP");
      liveSocket.execJS(this.el, this.el.dataset.onMouseUp);
    });
  }
}

export default makeHook(OnMouseUpHook);
