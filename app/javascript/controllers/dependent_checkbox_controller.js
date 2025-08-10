import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dependant", "dependee"]
  
  connect() {
    this.updateDependency()
  }
  
  input(event) {
    this.updateDependency()
    this.updateButtonStates()
  }
  
  updateDependency() {
    const dependant = this.dependantTarget // Editor checkbox
    const dependee = this.dependeeTarget   // Reader checkbox
    
    if (dependant.checked) {
      // If editor is checked, reader must also be checked
      dependee.checked = true
    }
  }
  
  updateButtonStates() {
    // Update visual states of permission buttons
    const editorBtn = this.dependantTarget.closest('.permission__btn')
    const readerBtn = this.dependeeTarget.closest('.permission__btn')
    
    if (this.dependantTarget.checked) {
      editorBtn.classList.add('permission__btn--active')
    } else {
      editorBtn.classList.remove('permission__btn--active')
    }
    
    if (this.dependeeTarget.checked) {
      readerBtn.classList.add('permission__btn--active')
    } else {
      readerBtn.classList.remove('permission__btn--active')
    }
  }
}