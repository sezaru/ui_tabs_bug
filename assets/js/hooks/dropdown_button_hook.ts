import { Hook, makeHook } from "phoenix_typed_hook";

class DropdownButtonHook extends Hook {
  mounted() {
    // this.dropdown = this.el
    // this.button = document.querySelector(`#${this.el.dataset.buttonId}`)
    // console.assert(this.button != null)
    // const offsetSkidding = 0
    // const offsetDistance = 0
    // this.placement = "bottom"
    // this.cleanup = autoUpdate(this.button, this.dropdown, () => {
    //     this.doComputePosition()
    // })
  }

  updated() {
    console.log("GOT HERE");
  }

  destroyed() {
    // this.cleanup()
  }
}

export default makeHook(DropdownButtonHook);
