import { render, createRef } from "preact";
import { unmountComponentAtNode } from "preact/compat";
import { PluginKey } from "@tiptap/pm/state";

import tippy from "tippy.js";

import SuggestionMenu from "./suggestion_menu";
import MustacheMenu from "./mustache_menu";

const userSuggestion = (hook) => {
  return {
    pluginKey: new PluginKey("user"),
    char: "@",
    items: async ({ query }) => {
      let promiseResolve = null;

      const promise = new Promise((resolve, _reject) => {
        promiseResolve = resolve;
      });

      hook.pushEvent("blibsblobs", { query: query }, ({ results }, ref) => {
        promiseResolve(results);
      });

      const results = await promise;

      return results;
    },
    render: () => {
      let popup;
      let componentRef;
      let element;

      return {
        onStart: (props) => {
          if (!props.clientRect) {
            return;
          }

          element = document.createElement("div");

          componentRef = createRef();

          render(
            <SuggestionMenu
              ref={componentRef}
              items={props.items}
              command={props.command}
            />,
            element,
          );

          popup = tippy("body", {
            getReferenceClientRect: props.clientRect,
            appendTo: () => document.body,
            content: element,
            showOnCreate: true,
            interactive: true,
            trigger: "manual",
            placement: "bottom-start",
          });
        },

        onUpdate(props) {
          render(
            <SuggestionMenu
              ref={componentRef}
              items={props.items}
              command={props.command}
            />,
            element,
          );

          popup[0].setContent(element);

          if (!props.clientRect) {
            return;
          }

          popup[0].setProps({
            getReferenceClientRect: props.clientRect,
          });
        },

        onKeyDown(props) {
          if (props.event.key === "Escape") {
            popup[0].hide();

            return true;
          }

          return componentRef.current.onKeyDown(props);
        },

        onExit() {
          unmountComponentAtNode(element);
          popup[0].destroy();
        },
      };
    },
  };
};

const mustacheSuggestion = (hook) => {
  return {
    pluginKey: new PluginKey("mustache"),
    char: "{{",
    items: async ({ query }) => {
      let promiseResolve = null;

      const promise = new Promise((resolve, _reject) => {
        promiseResolve = resolve;
      });

      hook.pushEvent("mustache", { query: query }, ({ results }, ref) => {
        promiseResolve(results);
      });

      const results = await promise;

      return results;
    },
    render: () => {
      let popup;
      let componentRef;
      let element;

      return {
        onStart: (props) => {
          if (!props.clientRect) {
            return;
          }

          element = document.createElement("div");

          componentRef = createRef();

          render(
            <MustacheMenu
              ref={componentRef}
              items={props.items}
              command={props.command}
            />,
            element,
          );

          popup = tippy("body", {
            getReferenceClientRect: props.clientRect,
            appendTo: () => document.body,
            content: element,
            showOnCreate: true,
            interactive: true,
            trigger: "manual",
            placement: "bottom-start",
          });
        },

        onUpdate(props) {
          render(
            <MustacheMenu
              ref={componentRef}
              items={props.items}
              command={props.command}
            />,
            element,
          );

          popup[0].setContent(element);

          if (!props.clientRect) {
            return;
          }

          popup[0].setProps({
            getReferenceClientRect: props.clientRect,
          });
        },

        onKeyDown(props) {
          if (props.event.key === "Escape") {
            popup[0].hide();

            return true;
          }

          return componentRef.current.onKeyDown(props);
        },

        onExit() {
          unmountComponentAtNode(element);
          popup[0].destroy();
        },
      };
    },
  };
};

export { userSuggestion, mustacheSuggestion };
