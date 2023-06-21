import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quantity"
export default class extends Controller {
  increment() {
    var numberField = document.getElementById("number_field")
    let currentValue = parseInt(numberField.value);
    numberField.value = currentValue + 1;
  }
  decrement() {
    var numberField = document.getElementById("number_field")
    let currentValue = parseInt(numberField.value);
    if (currentValue > 1) {
      numberField.value = currentValue - 1;
    }
  }
}
