import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  cancel() {
    const input = this.inputElement();
    input.classList.add('!hidden');
    input.value = '';
    this.element.querySelector('a').classList.remove('!hidden');
  }

  showInput() {
    const input = this.inputElement();
    input.classList.remove('!hidden');
    input.focus();
    this.element.querySelector('a').classList.add('!hidden');
  }

  inputElement() {
    return this.element.querySelector('input[type=text]');
  }
}
