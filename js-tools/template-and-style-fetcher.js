const el = document.getElementById("container");

function walker(el, {parent, styles, classCounter}) {
  if (el.nodeName == '#text') {
    parent.appendChild(document.createTextNode(el.data));
    return;
  }
  
  const node = document.createElement(el.nodeName);
  const style = window.getComputedStyle(el).cssText;
  
  let clazz = styles[style];
  
  if (!clazz) {
    clazz = 'cl-' + (classCounter++);
    styles[style] = clazz;
  }
  
  node.classList.add(clazz);
  parent.appendChild(node);
  
  el.childNodes.forEach((child, rest) => walker(child, {parent: node, styles, classCounter}))
}

const ctx = {
  parent:document.createElement('div'),
  styles: {},
  classCounter: 0
};

walker(el, ctx);

const codeValue = '<style>\n'
  + Object
      .entries(ctx.styles)
      .map(([style, clazz]) => '.' + clazz + ' {\n' + style + '\n}')
      .join('\n\n')
  + '\n</style>\n\n'
  + ctx.parent.innerHTML;
console.log(codeValue);
