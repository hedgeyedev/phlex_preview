import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["previewBtn", "codeBtn", "sourceBtn", "preview", "code", "source"];

  showCode() {
    this.activate({displayTarget: this.codeTarget, buttonTarget: this.codeBtnTarget});
    this.deactivate({displayTarget: this.previewTarget, buttonTarget: this.previewBtnTarget});
    this.deactivate({displayTarget: this.sourceTarget, buttonTarget: this.sourceBtnTarget});
  }

  showComponentSource() {
    this.activate({displayTarget: this.sourceTarget, buttonTarget: this.sourceBtnTarget});
    this.deactivate({displayTarget: this.codeTarget, buttonTarget: this.codeBtnTarget});
    this.deactivate({displayTarget: this.previewTarget, buttonTarget: this.previewBtnTarget});
  }

  showPreview() {
    this.activate({displayTarget: this.previewTarget, buttonTarget: this.previewBtnTarget});
    this.deactivate({displayTarget: this.codeTarget, buttonTarget: this.codeBtnTarget});
    this.deactivate({displayTarget: this.sourceTarget, buttonTarget: this.sourceBtnTarget});
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
