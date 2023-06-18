import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() { }

  update() {
    const categoryId = this.element.value;
    const subcategorySelect = document.querySelector('#subcategorySelect');
    
    subcategorySelect.innerHTML = '';

    if (categoryId) {
      fetch(`/product_subcategories/${categoryId}/subcategories`)
        .then(response => response.json())
        .then(data => {

          if (data.length > 0) {
            this.setDisabledSelect(subcategorySelect, 'Selecione uma subcategoria');
            
            data.forEach(({ name, id }) => this.setOption(subcategorySelect, name, id));
            
            subcategorySelect.disabled = false;
          }
          else {
            this.setDisabledSelect(subcategorySelect, 'Nenhuma subcategoria encontrada');
          }
        });
    }
    else {
      this.setDisabledSelect(subcategorySelect, 'Selecione uma subcategoria');
    }
  }

  setOption(select, description, value) {
    const option = document.createElement('option');
  
    option.value = value
    option.text = description;
    select.appendChild(option);
  }

  setDisabledSelect(select, description) {
    this.setOption(select, description);

    select.firstElementChild.disabled = true;
    select.disabled = true;
  }
}
