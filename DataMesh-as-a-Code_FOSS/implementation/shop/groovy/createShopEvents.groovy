// This is part of a Streamsets pipeline
records = sdc.records
for (record in records) {
//    try {

        // --------------------------------------------------------------------
        // Build empty events
        // --------------------------------------------------------------------

      	// Calculate Event list
		def recordList = []
		assert recordList.empty
        rnd = new Random()
		
		int timeOffset = 0

		// Max back to search from delete
		for (int del = 1; del <= 3; del++)
		{

			// Max back to search from prod2cart
			for (int p2c = 1; p2c <= 3; p2c++)
			{
		
				// Max back to search from nav2prod
				for (int n2p = 1; n2p <= 3; n2p++)
				{

					// 1. Search
					// Create Search Event
					int searchNum = 0;
                    newRecord = sdc.createRecord(record.sourceId + ':newRecordId')
					newRecord.value = sdc.createMap(true)
					newRecord.value['type'] = 'SEARCH'
					newRecord.value['Wait'] = 0
					newRecord.value['wexp'] = Character.toString((char)(97 + rnd.nextInt(26))) + '*' + Character.toString((char)(97 + rnd.nextInt(26)))
					// sdc.output.write(newRecord)
					recordList << newRecord

					if ((int)(Math.random()*100+1) <= 66 && searchNum <= 5) {
						newRecord = sdc.createRecord(record.sourceId + ':newRecordId')
						newRecord.value = sdc.createMap(true)
						newRecord.value['type'] = 'SEARCH'
						newRecord.value['Wait'] = (int)(Math.random()*27)+3
						newRecord.value['wexp'] = Character.toString((char)(97 + rnd.nextInt(26))) + '*' + Character.toString((char)(97 + rnd.nextInt(26)))
						timeOffset += newRecord.value['Wait']
						searchNum++
						// sdc.output.write(newRecord)
						recordList << newRecord
					}
					
					// 2. Navigate
					newRecord = sdc.createRecord(record.sourceId + ':newRecordId')
					//newRecord.value = ['type' : 'PRODUCT', 'Wait' : (int)(Math.random()*57)+3, 'wexp' : '']
					newRecord.value = sdc.createMap(true)
					newRecord.value['type'] = 'PRODUCT'
					newRecord.value['Wait'] = (int)(Math.random()*57)+3
					newRecord.value['wexp'] = ''
					timeOffset += newRecord.value['Wait']
					// sdc.output.write(newRecord)
					recordList << newRecord					
					if ((int)(Math.random()*100+1) <= 80)
					{
						// Put the product to the cart
						break
					}
				}		

				// 3. Add Product to Cart
				newRecord = sdc.createRecord(record.sourceId + ':newRecordId')
				// newRecord.value = ['type' : 'INTOCART', 'Wait' : (int)(Math.random()*115)+5, 'wexp' : '']
				newRecord.value = sdc.createMap(true)
				newRecord.value['type'] = 'INTOCART'
				newRecord.value['Wait'] = (int)(Math.random()*115)+5
				newRecord.value['wexp'] = ''
				timeOffset += newRecord.value['Wait']
				// sdc.output.write(newRecord)
				recordList << newRecord
				if ((int)(Math.random()*100+1) <= 80)
				{
					// Delete all irrelevant products
					break
				}

			}

			// 4. Delete Product from Cart
			newRecord = sdc.createRecord(record.sourceId + ':newRecordId')
			// newRecord.value = ['type' : 'DELETE', 'Wait' : (int)(Math.random()*28)+2, 'wexp' : '']
			newRecord.value = sdc.createMap(true)
			newRecord.value['type'] = 'DELETE'
			newRecord.value['Wait'] = (int)(Math.random()*28)+2
			newRecord.value['wexp'] = ''
			timeOffset += newRecord.value['Wait']
			// sdc.output.write(newRecord)
			recordList << newRecord
			if ((int)(Math.random()*100+1) <= 80)
			{
				// Checkout the cart
				break
			}

		}

      	// 5. Checkout Cart
		newRecord = sdc.createRecord(record.sourceId + ':newRecordId')
		// newRecord.value = ['type' : 'CHECKOUT', 'Wait' : (int)(Math.random()*18)+2, 'wexp' : '']
		newRecord.value = sdc.createMap(true)
		newRecord.value['type'] = 'CHECKOUT'
		newRecord.value['Wait'] = (int)(Math.random()*18)+2
		newRecord.value['wexp'] = ''
		timeOffset += newRecord.value['Wait']
		// sdc.output.write(newRecord)
		recordList << newRecord
		
        // --------------------------------------------------------------------
        // Fill events with content from order and write
        // --------------------------------------------------------------------

		// FINAL - Loop through event records, enhance an write
        int os = 0
		recordList.each 
		{
            // Only if earliest event timestamp is 0 or positive
            if (timeOffset * 1000 <= record.value['delay_from_start_ms'])
            {
				os += it.value['Wait'] * 1000
                it.value['delay_from_start_ms'] = record.value['delay_from_start_ms'] - (timeOffset * 1000) + os
                it.value['id'] = record.value['salesOrder']['id']
                it.value['customerId'] = record.value['salesOrder']['customerId']
                it.value['billToAddressId'] = record.value['salesOrder']['billToAddressId']
                it.value['shipToAddressId'] = record.value['salesOrder']['shipToAddressId']
                it.value['itemId'] = record.value['salesOrder']['orderDetails'][0]['id']
                it.value['productId'] = record.value['salesOrder']['orderDetails'][0]['productId']
                sdc.output.write(it)
            }

		}

		record.value['offset'] = timeOffset
		// sdc.output.write(record)


    //    } catch (e) {
    //        sdc.log.error(e.toString(), e)
    //        sdc.error.write(record, e.toString())
    //    }
}