import { Controller } from "@hotwired/stimulus"
import * as monaco from "monaco-editor"

export default class extends Controller {
  static targets = ["editor", "ruby"];

  connect() {
    // this.editorTarget.style.height = ``;
    this.editor = monaco.editor.create(this.editorTarget, {
      value: this.source(),
      language: "ruby",
      theme: "vs-dark",
      scrollBeyondLastLine: false,
      fontSize: 14,
      automaticLayout: true,
    });
  }

  saveSource() {
    this.rubyTarget.textContent = this.editor.getValue();
  }

  source() {
    return this.rubyTarget.textContent;
  }
}
