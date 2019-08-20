let items = document.querySelectorAll('.list')
items.forEach( item => {
  item.addEventListener('dragstart', dragStart)
  item.addEventListener('drop', dropped)
  item.addEventListener('dragenter', cancelDefault)
  item.addEventListener('dragover', cancelDefault)
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
}

function cancelDefault(ev){
  ev.preventDefault()
  ev.stopPropagation()
  return false
}