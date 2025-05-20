import { basicSetup, EditorView } from "codemirror";

const view = new EditorView({
    doc: 'Hello Editor',
    parent: document.querySelector('#editor'),
    extensions: [basicSetup]
})

export default view