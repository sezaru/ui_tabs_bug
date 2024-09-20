// import Utils from "./utils"

import { Hook, makeHook } from "phoenix_typed_hook";

class HideElementHook extends Hook {
  mounted() {
    this.el.addEventListener("change", () => {
      this.doUpdate();
    });
  }

  beforeUpdate() {}

  updated() {}

  destroyed() {}

  doUpdate() {
    // if (this.el.checked) {
    //     liveSocket.execJS(this.el, this.el.dataset.onShow)
    // } else {
    //     liveSocket.execJS(this.el, this.el.dataset.onHide)
    // }
  }
}

export default makeHook(HideElementHook);
