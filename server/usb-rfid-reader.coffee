usb = Meteor.npmRequire 'usb'

devices = usb.getDeviceList()

hexKeys =
  '00' : null
  '02' : ''
  '1e' : '1'
  '1f' : '2'
  '20' : '3'
  '21' : '4'
  '22' : '5'
  '23' : '6'
  '24' : '7'
  '25' : '8'
  '26' : '9'
  '27' : '0'
  '28' : '' # enter


for device in devices

  if device.deviceDescriptor.idVendor is 2689 and
  device.deviceDescriptor.idProduct is 517
    console.log 'found RFID scanning device!'
    try
      device.open()

      do startTransfer = Meteor.bindEnvironment ->

        theInterface = device.interfaces[0];

        if theInterface.isKernelDriverActive()
          theInterface.detachKernelDriver();

        theInterface.claim();

        theEndpoint = theInterface.endpoints[0];

        theEndpoint.transfer 16*12, Meteor.bindEnvironment (err,data) ->
          code = ""

          if data
            hex = data.toString('hex')
            # parse hex string into key code
            for char, i in hex by 2
              hexVal = hexKeys["#{hex[i]}#{hex[i+1]}"]
              if hexVal
                code += hexVal

          if code
            try
              Meteor.call 'requestAccess',
                loginType: 'card'
                _cardId: code

          device.reset startTransfer

      break

    catch e
      console.log 'Problem with RFID scanner.', e
