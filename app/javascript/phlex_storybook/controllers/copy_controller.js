import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["btn", "source"];

  copy(event) {
    event.preventDefault();
    const text = this.sourceTarget.textContent;
    const originalHtml = event.target.htmlContent;
    navigator.clipboard.writeText(text).then(() => {
      this.btnTarget.querySelector('.clipboard').classList.add('hidden');
      this.btnTarget.querySelector('.check').classList.remove('hidden');
      setTimeout(() => {
        this.btnTarget.querySelector('.clipboard').classList.remove('hidden');
        this.btnTarget.querySelector('.check').classList.add('hidden');
      }, 1000);
    }).catch(err => {
      console.error('Failed to copy text: ', err);
    });
  }

  enable() {
    this.btnTarget.disabled = false;
    // this.btnTarget.querySelector('.clipboard').classList.remove("stroke-slate-500");
    // this.btnTarget.classList.add("text-slate-100");
  }

  disable() {
    this.btnTarget.disabled = true;
    // this.btnTarget.classList.add("text-slate-500");
    // this.btnTarget.classList.remove("text-slate-100");
  }
}
