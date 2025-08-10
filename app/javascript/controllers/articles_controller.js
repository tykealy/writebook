import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["grid", "filterBtn", "viewBtn", "card"]
  
  connect() {
    this.initializeFilters()
    this.initializeViewControls()
  }
  
  initializeFilters() {
    // Set up filter button event listeners
    this.filterBtnTargets.forEach(btn => {
      btn.addEventListener('click', (e) => this.filterArticles(e))
    })
    
    // Set initial active filter
    if (this.filterBtnTargets.length > 0) {
      this.filterBtnTargets[0].classList.add('filter__btn--active')
    }
  }
  
  initializeViewControls() {
    // Set up view button event listeners
    this.viewBtnTargets.forEach(btn => {
      btn.addEventListener('click', (e) => this.switchView(e))
    })
  }
  
  filterArticles(event) {
    const filterValue = event.target.dataset.filter
    
    // Update active filter button
    this.filterBtnTargets.forEach(btn => btn.classList.remove('filter__btn--active'))
    event.target.classList.add('filter__btn--active')
    
    // Filter articles
    this.cardTargets.forEach(card => {
      const cardStatus = card.dataset.status
      let shouldShow = false
      
      switch (filterValue) {
        case 'all':
          shouldShow = true
          break
        case 'published':
          shouldShow = cardStatus === 'published'
          break
        case 'draft':
          shouldShow = cardStatus === 'draft'
          break
      }
      
      if (shouldShow) {
        card.style.display = 'block'
        card.style.animation = 'fadeInUp 0.3s ease-out'
      } else {
        card.style.display = 'none'
      }
    })
    
    // Update stats if they exist
    this.updateStats(filterValue)
  }
  
  switchView(event) {
    const viewType = event.target.closest('.view__btn').dataset.view
    
    // Update active view button
    this.viewBtnTargets.forEach(btn => btn.classList.remove('view__btn--active'))
    event.target.closest('.view__btn').classList.add('view__btn--active')
    
    // Update grid view
    if (this.hasGridTarget) {
      this.gridTarget.setAttribute('data-view', viewType)
    }
  }
  
  updateStats(filterValue) {
    // This could update visible statistics based on filtered results
    const visibleCards = this.cardTargets.filter(card => 
      window.getComputedStyle(card).display !== 'none'
    )
    
    // You could update a stats display here if needed
    console.log(`Showing ${visibleCards.length} articles for filter: ${filterValue}`)
  }
}

// Add CSS animations
const style = document.createElement('style')
style.textContent = `
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  @keyframes scaleIn {
    from {
      opacity: 0;
      transform: scale(0.95);
    }
    to {
      opacity: 1;
      transform: scale(1);
    }
  }
  
  .article-card {
    animation: scaleIn 0.3s ease-out;
  }
`
document.head.appendChild(style)
