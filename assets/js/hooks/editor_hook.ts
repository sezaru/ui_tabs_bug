import { Hook, makeHook } from "phoenix_typed_hook";

import { userSuggestion, mustacheSuggestion } from "./editor_hook/suggestion";

import { Editor } from "@tiptap/core";

import Document from "@tiptap/extension-document";
import Paragraph from "@tiptap/extension-paragraph";
import Text from "@tiptap/extension-text";
import Bold from "@tiptap/extension-bold";
import Italic from "@tiptap/extension-italic";
import Mention from "@tiptap/extension-mention";

import { Extension } from "@tiptap/core";

const CustomExtension = Extension.create({
  onBeforeCreate({ editor }) {
    console.log("onBeforeCreate");
    // Before the view is created.
  },
  onCreate({ editor }) {
    console.log("onCreate");
    // The editor is ready.
  },
  onUpdate({ editor }) {
    console.log("onUpdate");
    // The content has changed.
  },
  onSelectionUpdate({ editor }) {
    console.log("onSelectionUpdate");
    // The selection has changed.
  },
  onTransaction({ editor, transaction }) {
    console.log("onTransaction");
    console.log(transaction);
    // The editor state has changed.
  },
  onFocus({ editor, event }) {
    console.log("onFocus");
    // The editor is focused.
  },
  onBlur({ editor, event }) {
    console.log("onBlur");
    // The editor isn’t focused anymore.
  },
  onDestroy() {
    console.log("onDestroy");
    // The editor is being destroyed.
  },
  onContentError({ editor, error, disableCollaboration }) {
    console.log("onContentError");
    // The editor content does not match the schema.
  },
});

class EditorHook extends Hook {
  mounted() {
    const buttons = this.el.querySelectorAll("div[events_buttons] button");

    this.buttonMap = this.createButtonMap(buttons);
    this.toggleMap = this.createToggleMap();

    const editorElement = this.el.querySelector("div#editor_editor");

    this.input = this.el.querySelector("input#editor_input");

    const mustacheMention = Mention.configure({
      HTMLAttributes: {
        class: "bg-red-100 font-bold",
      },
      renderText({ options, node }) {
        return `${options.suggestion.char}${node.attrs.label ?? node.attrs.id}`;
      },
      // renderHTML({ options, node }) {
      //   return "blibs"
      //   // return [
      //   //   "span",
      //   //   mergeAttributes({ href: "/profile/1" }, this.HTMLAttributes),
      //   //   `${options.suggestion.char}${node.attrs.label ?? node.attrs.id}`,
      //   // ]
      // },
      suggestion: mustacheSuggestion(this),
    }).extend({ name: "mention" });

    const userMention = Mention.configure({
      HTMLAttributes: {
        class: "bg-green-100",
      },
      deleteTriggerWithBackspace: true,
      renderText({ options, node }) {
        return `${options.suggestion.char}${node.attrs.label ?? node.attrs.id}`;
      },
      // renderHTML({ options, node }) {
      //   return [
      //     "span",
      //     mergeAttributes({ href: "/profile/1" }, this.HTMLAttributes),
      //     `${options.suggestion.char}${node.attrs.label ?? node.attrs.id}`,
      //   ]
      // },
      suggestion: userSuggestion(this),
    }).extend({ name: "user_suggestion" });

    const editorClass = this.el.dataset.editorClass;
    const extensions = [
      Bold,
      Italic,
      Document,
      Paragraph,
      Text,
      // userMention,
      mustacheMention,
      //CustomExtension
    ];

    this.editor = new Editor({
      element: editorElement,
      extensions: extensions,
      editorProps: { attributes: { class: editorClass } },
      content: this.input.value,
      injectCSS: false,
    });

    // this.editor.on("selectionUpdate", ({editor}) => this.updated())

    this.editor.on("transaction", ({ editor }) => this.updated());

    this.editor.on("update", ({ editor }) => {
      this.input.value = this.editor.getHTML();

      this.input.dispatchEvent(new Event("change", { bubbles: true }));
    });

    this.el.addEventListener("editor_event", ({ detail }) => {
      this.handleEditorEvent(detail);
    });
  }

  beforeUpdate() {}

  updated() {
    Object.keys(this.buttonMap).forEach((event) => this.checkEvent(event));
  }

  destroyed() {}

  handleEditorEvent({ dispatcher }) {
    this.toggleEvent(dispatcher.dataset.eventType);
  }

  toggleEvent(event) {
    this.toggleMap[event](this.editor).run();
    this.checkEvent(event);
  }

  checkEvent(event) {
    const condition = this.booleanAsString(this.editor.isActive(event));

    this.buttonMap[event].setAttribute("aria-pressed", condition);
  }

  createButtonMap(buttons) {
    return Array.from(buttons, (e) => e).reduce((map, button) => {
      map[button.dataset.eventType] = button;

      return map;
    }, {});
  }

  createToggleMap() {
    return {
      bold: (editor) => editor.chain().focus().toggleBold(),
      italic: (editor) => editor.chain().focus().toggleItalic(),
    };
  }

  booleanAsString(condition) {
    return condition ? "true" : "false";
  }
}

export default makeHook(EditorHook);
