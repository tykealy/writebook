import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea"]
  
  connect() {
    this.initializeToolbar()
  }
  
  initializeToolbar() {
    // Add keyboard shortcuts
    this.textareaTarget.addEventListener('keydown', (e) => {
      if (e.metaKey || e.ctrlKey) {
        switch (e.key) {
          case 'b':
            e.preventDefault()
            this.bold()
            break
          case 'i':
            e.preventDefault()
            this.italic()
            break
          case 'k':
            e.preventDefault()
            this.link()
            break
        }
      }
    })
  }
  
  bold() {
    this.wrapSelection('**', '**', 'bold text')
  }
  
  italic() {
    this.wrapSelection('*', '*', 'italic text')
  }
  
  code() {
    this.wrapSelection('`', '`', 'code')
  }
  
  link() {
    const url = prompt('Enter URL:')
    if (url) {
      this.wrapSelection('[', `](${url})`, 'link text')
    }
  }
  
  image() {
    const url = prompt('Enter image URL:')
    if (url) {
      const alt = prompt('Enter alt text (optional):') || 'image'
      this.insertText(`![${alt}](${url})`)
    }
  }
  
  bullets() {
    this.insertListItem('- ')
  }
  
  numbers() {
    this.insertListItem('1. ')
  }
  
  quote() {
    this.insertLinePrefix('> ')
  }
  
  wrapSelection(before, after, placeholder = '') {
    const textarea = this.textareaTarget
    const start = textarea.selectionStart
    const end = textarea.selectionEnd
    const selectedText = textarea.value.substring(start, end)
    const replacement = selectedText || placeholder
    
    const beforeText = textarea.value.substring(0, start)
    const afterText = textarea.value.substring(end)
    
    textarea.value = beforeText + before + replacement + after + afterText
    
    // Set cursor position
    if (selectedText) {
      textarea.selectionStart = start
      textarea.selectionEnd = end + before.length + after.length
    } else {
      const newStart = start + before.length
      textarea.selectionStart = newStart
      textarea.selectionEnd = newStart + placeholder.length
    }
    
    textarea.focus()
    this.triggerChange()
  }
  
  insertText(text) {
    const textarea = this.textareaTarget
    const start = textarea.selectionStart
    const end = textarea.selectionEnd
    
    const beforeText = textarea.value.substring(0, start)
    const afterText = textarea.value.substring(end)
    
    textarea.value = beforeText + text + afterText
    
    const newPosition = start + text.length
    textarea.selectionStart = newPosition
    textarea.selectionEnd = newPosition
    
    textarea.focus()
    this.triggerChange()
  }
  
  insertListItem(prefix) {
    const textarea = this.textareaTarget
    const start = textarea.selectionStart
    const beforeText = textarea.value.substring(0, start)
    
    // Check if we're at the beginning of a line
    const lines = beforeText.split('\n')
    const currentLine = lines[lines.length - 1]
    
    if (currentLine.trim() === '') {
      // We're at an empty line, just add the prefix
      this.insertText(prefix)
    } else {
      // Add a new line with the prefix
      this.insertText('\n' + prefix)
    }
  }
  
  insertLinePrefix(prefix) {
    const textarea = this.textareaTarget
    const start = textarea.selectionStart
    const end = textarea.selectionEnd
    
    const beforeText = textarea.value.substring(0, start)
    const selectedText = textarea.value.substring(start, end)
    const afterText = textarea.value.substring(end)
    
    // Find the start of the current line
    const lines = beforeText.split('\n')
    const currentLineStart = beforeText.length - lines[lines.length - 1].length
    
    if (selectedText.includes('\n')) {
      // Multi-line selection
      const selectedLines = selectedText.split('\n')
      const prefixedLines = selectedLines.map(line => prefix + line)
      const newText = prefixedLines.join('\n')
      
      textarea.value = beforeText + newText + afterText
      textarea.selectionStart = start
      textarea.selectionEnd = start + newText.length
    } else {
      // Single line
      const lineStart = beforeText.substring(0, currentLineStart)
      const currentLine = beforeText.substring(currentLineStart)
      
      textarea.value = lineStart + prefix + currentLine + selectedText + afterText
      textarea.selectionStart = start + prefix.length
      textarea.selectionEnd = end + prefix.length
    }
    
    textarea.focus()
    this.triggerChange()
  }
  
  triggerChange() {
    // Trigger change event for any listeners (like autosave)
    this.textareaTarget.dispatchEvent(new Event('input', { bubbles: true }))
  }
}
