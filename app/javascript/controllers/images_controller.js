import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="images"
export default class extends Controller {
  change() {
    const displayedImage = document.querySelector("#displayed-image");
    displayedImage.src = this.element.src;
  }
}
