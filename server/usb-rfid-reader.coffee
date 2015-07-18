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
    try
      device.open()

      do startTransfer = ->


        theInterface = device.interfaces[0];

        if theInterface.isKernelDriverActive()
          theInterface.detachKernelDriver();

        try
          theInterface.claim();
        catch
          console.log 'Failed to claim interface'

        theEndpoint = theInterface.endpoints[0];


        test = Meteor.wrapAsync (callback) ->
          theEndpoint.transfer 180, (err, data) ->
            code = ""
            if data
              hex = data.toString('hex')
              # parse hex string into key code
              for char, i in hex by 2
                hexVal = hexKeys["#{hex[i]}#{hex[i+1]}"]
                if hexVal
                  code += hexVal

            callback null, code

        thisCode = test()

        Meteor.call 'requestAccess',
          loginType: 'card'
          _cardId: thisCode

        # TODO -- reset is a hack; otherwise transfered data is not consistent
        device.reset startTransfer

      break

    catch e
      console.log 'Problem with RFID scanner.', e