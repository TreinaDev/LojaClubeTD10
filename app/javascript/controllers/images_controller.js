import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="images"
export default class extends Controller {
  change() {
    const thumbs = document.querySelectorAll('.thumb-images');
    thumbs.forEach(image => image.classList.remove('border', 'border-dark'));
    this.element.classList.add('border', 'border-dark');

    const displayedImage = document.querySelector('#displayed-image');
    displayedImage.src = this.element.src;
  }
}
