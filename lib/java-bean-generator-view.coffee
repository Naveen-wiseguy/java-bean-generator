module.exports =
class JavaBeanGeneratorView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('java-bean-generator')

    # Create message element
    @message1 = document.createElement('div')
    @message1.textContent = "Enter the bean name :"
    @message1.classList.add('message')
    @beanName=document.createElement('atom-text-editor')
    @beanName.setAttribute('mini',true)
    @message2 = document.createElement('div')
    @message2.textContent = "Enter the properies as name:type separated by spaces :"
    @message2.classList.add('message')
    @beanProp=document.createElement('atom-text-editor')
    @beanProp.setAttribute('mini',true)
    @element.appendChild(@message1)
    @element.appendChild(@beanName)
    @element.appendChild(@message2)
    @element.appendChild(@beanProp)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @beanName=null
    @beanProp=null

  getElement: ->
    @element

#Returns the contents of the bean name text box
  getBeanName: ->
    @beanName.getModel().getText()

#Returns the contents of the bean properties text box
  getBeanProp: ->
    @beanProp.getModel().getText()

  error: (err) ->
    @errorbox=document.createElement('div')
    @errorbox.textContent =err
    @errorbox.classList.add('error')
    @element.appendChild(@errorbox)
