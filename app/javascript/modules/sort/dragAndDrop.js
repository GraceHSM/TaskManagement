let lists = document.querySelectorAll('.list')
lists.forEach( list => {
  list.addEventListener('dragstart', dragStart)
  list.addEventListener('drop', dropped)
  list.addEventListener('dragenter', cancelDefault)
  list.addEventListener('dragover', cancelDefault)
})

function dragStart (ev) {
  var index = ev.target.querySelector('td input').id
  ev.dataTransfer.setData('text', index)
}

function dropped (ev){
  cancelDefault(ev)

  // get new and old index
  let oldIndex = ev.dataTransfer.getData('text')
  let target = ev.currentTarget
  let newIndex = target.querySelector('td input').id

  // remove dropped items at old place
  // let dropped = $(this).parent().children().eq(oldIndex).remove()

  // insert the dropped items at new place
  // if (newIndex < oldIndex) {
  //   target.before(dropped)
  // } else {
  //   target.after(dropped)
  // }
}

function cancelDefault(ev){
  ev.preventDefault()
  ev.stopPropagation()
  return false
}