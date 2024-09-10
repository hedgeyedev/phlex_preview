import { Controller } from "@hotwired/stimulus";
import * as monaco from "monaco-editor"

export default class extends Controller {
  static targets = [
    "code",
    "codeBtn",
    "editor",
    "preview",
    "previewBtn",
    "ruby",
    "source",
    "sourceBtn",
  ];

  getComponentSource() {
    return this.rubyTarget.textContent;
  }

  saveComponentSource() {
    this.rubyTarget.textContent = this.editor.getValue();
  }

  showCode() {
    this.activate({displayTarget: this.codeTarget, buttonTarget: this.codeBtnTarget});
    this.deactivate({displayTarget: this.previewTarget, buttonTarget: this.previewBtnTarget});
    this.deactivate({displayTarget: this.sourceTarget, buttonTarget: this.sourceBtnTarget});
    this.editor = null;
  }

  showComponentSource() {
    this.activate({displayTarget: this.sourceTarget, buttonTarget: this.sourceBtnTarget});
    this.deactivate({displayTarget: this.codeTarget, buttonTarget: this.codeBtnTarget});
    this.deactivate({displayTarget: this.previewTarget, buttonTarget: this.previewBtnTarget});
    this.editorTarget.style.height = `${this.element.clientHeight * 0.66}px`;
    this.editor = monaco.editor.create(this.editorTarget, {
      value: this.getComponentSource(),
      language: "ruby",
      theme: "vs-dark",
    });
  }

  showPreview() {
    this.activate({displayTarget: this.previewTarget, buttonTarget: this.previewBtnTarget});
    this.deactivate({displayTarget: this.codeTarget, buttonTarget: this.codeBtnTarget});
    this.deactivate({displayTarget: this.sourceTarget, buttonTarget: this.sourceBtnTarget});
    this.editor = null;
  }

  activate({displayTarget, buttonTarget}) {
    displayTarget.classList.remove('hidden');
    buttonTarget.classList.add('story-button-active');
  }

  deactivate({displayTarget, buttonTarget}) {
    displayTarget.classList.add('hidden');
    buttonTarget.classList.remove('story-button-active');
  }
}
