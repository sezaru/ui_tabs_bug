import { Hook, makeHook } from "phoenix_typed_hook";

// import TomSelect from "tom-select/dist/js/tom-select.base";
//import TomSelect from "tom-select";
import SlimSelect from "slim-select";

class ComboBoxHook extends Hook {
  mounted() {
    const select = this.el.querySelector("select");

    const settings = {
      showSearch: true,
      searchPlaceholder: "Search Blibs",
      closeOnSelect: true,
      // hideSelect: false
    };

    const events = {
      beforeChange: (newValue: Option[], oldValue: Option[]) => {
        console.log(newValue);
        console.log(oldValue);
      },
      afterChange: (newValue: Option[]) => {
        select.dispatchEvent(new Event("change", { bubbles: true }));
        console.log(newValue);
      },
    };

    // this.tomSelect = new TomSelect(this.el.querySelector("select"), settings);

    this.slimSelect = new SlimSelect({
      select: select,
      settings: settings,
      events: events,
    });
  }

  updated() {}

  destroyed() {}
}

export default makeHook(ComboBoxHook);
