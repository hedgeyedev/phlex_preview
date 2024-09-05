import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["previewBtn", "codeBtn", "preview", "code"];

  showCode() {
    this.previewTarget.classList.add('hidden');
    this.codeTarget.classList.remove('hidden');
    this.previewBtnTarget.classList.remove('story-preview-active');
    this.codeBtnTarget.classList.add('story-code-active');
  }

  showPreview() {
    this.previewTarget.classList.remove('hidden');
    this.codeTarget.classList.add('hidden');
    this.previewBtnTarget.classList.add('story-preview-active');
    this.codeBtnTarget.classList.remove('story-code-active');
  }
}
