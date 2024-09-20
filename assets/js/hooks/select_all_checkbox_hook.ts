import Utils from "./utils";

import { Hook, makeHook } from "phoenix_typed_hook";

class SelectAllCheckboxHook extends Hook {
  mounted() {
    this.checkboxes = Array.from(
      document.querySelectorAll("div#checkbox > input"),
    );

    this.checkboxes.forEach((checkbox) => {
      checkbox.addEventListener("change", ({ currentTarget }) => {
        this.checkSelected();
      });
    });

    this.checkSelected();

    this.el.addEventListener("change", () => {
      this.checkboxes.forEach((checkbox) => {
        checkbox.checked = this.el.checked;
      });

      this.checkboxes[0].dispatchEvent(new Event("change", { bubbles: true }));
    });
  }

  checkSelected() {
    const allChecked = this.checkboxes.every((checkbox) => checkbox.checked);

    if (allChecked) {
      this.el.checked = true;
      this.el.indeterminate = false;

      return;
    }

    const allUnchecked = this.checkboxes.every((checkbox) => !checkbox.checked);

    if (allUnchecked) {
      this.el.checked = false;
      this.el.indeterminate = false;

      return;
    }

    this.el.checked = false;
    this.el.indeterminate = true;
  }
}

export default makeHook(SelectAllCheckboxHook);
