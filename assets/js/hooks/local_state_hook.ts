// JS Hook for storing some state in sessionStorage or localStorage in the browser.
// The server requests stored data and clears it when requested.

import { Hook, makeHook } from "phoenix_typed_hook";

class LocalStateHook extends Hook {
  mounted() {
    this.handleEvent("session_storage:store", (object) =>
      this.sessionStorageStore(object),
    );
    this.handleEvent("session_storage:clear", (object) =>
      this.sessionStorageClear(object),
    );
    this.handleEvent("session_storage:restore", (object) =>
      this.sessionStorageRestore(object),
    );

    this.handleEvent("local_storage:store", (object) =>
      this.localStorageStore(object),
    );
    this.handleEvent("local_storage:clear", (object) =>
      this.localStorageClear(object),
    );
    this.handleEvent("local_storage:restore", (object) =>
      this.localStorageRestore(object),
    );
  }

  sessionStorageStore(object) {
    sessionStorage.setItem(object.key, object.data);
  }

  sessionStorageRestore(object) {
    const data = sessionStorage.getItem(object.key);

    this.pushEvent(object.event, data);
  }

  sessionStorageClear(object) {
    sessionStorage.removeItem(object.key);
  }

  localStorageStore(object) {
    localStorage.setItem(object.key, object.data);
  }

  localStorageRestore(object) {
    const data = localStorage.getItem(object.key);

    this.pushEvent(object.event, data);
  }

  localStorageClear(object) {
    localStorage.removeItem(object.key);
  }
}

export default makeHook(LocalStateHook);
