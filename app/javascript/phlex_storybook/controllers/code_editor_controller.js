import { Controller } from "@hotwired/stimulus"
import * as monaco from "monaco-editor"

export default class extends Controller {
  static targets = ["ruby"];

  connect() {
    monaco.editor.create(this.element, {value: this.source(), language: "ruby", theme: "vs-dark"});
  }

  source() {
    return this.rubyTarget.textContent;
  }
}
