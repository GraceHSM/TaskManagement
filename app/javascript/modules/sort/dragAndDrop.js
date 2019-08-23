let items = document.querySelectorAll('.list')
items.forEach( item => {
  item.addEventListener('dragstart', dragStart, false)
  item.addEventListener('drop', dropped, false)
  item.addEventListener('dragenter', dragEnter, false)
  item.addEventListener('dragleave', dragLeave, false)
  item.addEventListener('dragover', cancelDefault, false)
})

function dragStart (ev) {
  let index = ev.target.rowIndex - 1
  ev.dataTransfer.setData('text', index)
}

function dropped (ev){
  cancelDefault(ev)

  // Get drag element
  let lists = document.querySelectorAll('.list');
  let index = ev.dataTransfer.getData('text')
  let content = lists[index]

  // Drop place
  let target = ev.currentTarget

  //move drag element before drop element
  target.insertAdjacentElement('beforebegin', content)
  target.style.borderTop = 'none'
}

function dragEnter(ev){
  ev.currentTarget.style.borderTop = '5px solid #007bff'
}
function dragLeave(ev){
  ev.currentTarget.style.borderTop = 'none'
}
function cancelDefault(ev){
  ev.preventDefault()
  ev.stopPropagation()
}