JavaBeanGeneratorView = require './java-bean-generator-view'
{CompositeDisposable} = require 'atom'

module.exports = JavaBeanGenerator =
  javaBeanGeneratorView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @javaBeanGeneratorView = new JavaBeanGeneratorView(state.javaBeanGeneratorViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @javaBeanGeneratorView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'java-bean-generator:toggle': => @toggle()
    @subscriptions.add atom.commands.add @javaBeanGeneratorView.getElement(),
      'core:cancel': => @toggle()
      'core:confirm': => @process()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @javaBeanGeneratorView.destroy()

  serialize: ->
    javaBeanGeneratorViewState: @javaBeanGeneratorView.serialize()

  toggle: ->
    console.log 'JavaBeanGenerator was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  process: ->
    beanName=@javaBeanGeneratorView.getBeanName()
    beanProp=@javaBeanGeneratorView.getBeanProp()
    if(beanName.trim()=="")
      @javaBeanGeneratorView.error('Bean name cant be blank')
    else
      @createBean(beanName,beanProp)
      @toggle()


  createBean: (beanName,beanProp) ->
        @bean=atom.workspace.open()
        @bean.then((editor)->
                      editor.insertText("public class "+beanName+"\n{\n")
                      props=beanProp.split(/\s+/)
                      propNames=[] #holds all the property names
                      propTypes=[] #holds all the property types
                      for command in props
                        console.log(command+"\n")
                        parts=command.split(":")
                        propNames.push parts[0]
                        propTypes.push parts[1]
                        properties=""
                      #declarations of all properties
                      for property,index in propNames
                        console.log("Writing property:"+property+"\n")
                        properties=properties+"private "+propTypes[index]+" "+property+";\n"
                      properties+="\n"
                      #Add the constructor
                      properties=properties+"public "+beanName+"()\n{"
                      properties=properties+"\n}\n\n"
                      #creating getters and setters
                      for property,index in propNames
                        #setter first
                        properties=properties+"public set"+property.charAt(0).toUpperCase()+property.slice(1)
                        properties=properties+"("+propTypes[index]+" "+property+")\n"
                        properties=properties+"{\n\tthis."+property+"="+property+";\n}\n\n"
                        #getter next
                        properties=properties+propTypes[index]+" get"+property.charAt(0).toUpperCase()+property.slice(1)
                        properties=properties+"()\n{\n"
                        properties=properties+"\treturn "+property+";\n"
                        properties=properties+"}\n\n"
                      editor.insertText(properties)
                      editor.insertText("}")
                      @javaBeanGeneratorView.destroy
          )
