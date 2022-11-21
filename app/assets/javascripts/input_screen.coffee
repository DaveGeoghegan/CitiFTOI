jQuery ->
	$('.input-screen-table').editableTableWidget();

jQuery ->
	$('.slider').bootstrapSlider({
		ticks: [0, 1, 2, 3, 4],
		tooltip: 'hide'
	})

jQuery ->
	$('.slider').on slide: (event) ->
		console.log("Sliding..")
		console.log($(this))
		id = $(this)[0].getAttribute("data-slider-id")
		val_id = "#slider" + id + "Value"
		label = "Neutral"
		window.is_dirty = true
		if event.value == 0 then label = "Very Conservative"
		if event.value == 1 then label = "Conservative     "
		if event.value == 2 then label = "Neutral          "
		if event.value == 3 then label = "Liberal          "
		if event.value == 4 then label = "Very Liberal     "
		$(val_id).text(label)

jQuery ->
	$('.slider').on change: (event) ->
		console.log("xxSliding..")
		console.log($(this))
		console.log(event)
		id = $(this)[0].getAttribute("data-slider-id")
		val_id = "#slider" + id + "Value"
		label = "Neutral"
		window.is_dirty = true
		if event.value.newValue == 0 then label = "Very Conservative"
		if event.value.newValue == 1 then label = "Conservative"
		if event.value.newValue == 2 then label = "Neutral"
		if event.value.newValue == 3 then label = "Liberal"
		if event.value.newValue == 4 then label = "Very Liberal"
		$(val_id).text(label)

jQuery ->
	$('.discard-changes-button').click (event) ->
		theUrl = window.url_to_go_to
		window.url_to_go_to = ''
		window.location = theUrl

jQuery ->
	$('.reset-button').click (event) ->
		console.log("Reset")
		window.location.reload()

jQuery ->
	$('.save-changes-button').click (event) ->
		theUrl = window.url_to_go_to
		window.url_to_go_to = ''
		save_data(theUrl)

jQuery ->
	$('.navigation-button').click (event) ->
		console.log("Got A Click - Navigation Button");
		console.log($(this))
		console.log("Going for the each")
		theUrl = "/round/" + $(this)[0].getAttribute("data-round-id") + "/input_screen/" + $(this)[0].getAttribute("data-input-screen-id")
		if ok_to_move_on()
			location.replace theUrl
		else
			console.log("Launching Modal")
			$('#error_modal').modal()
			window.url_to_go_to = theUrl
		event.preventDefault()


window.is_dirty = false

ok_to_move_on = ->
	console.log("OK To Move On")
	if window.is_dirty
		return false
	else
		return true

save_data = (url) ->
	value_good = true
	$.each $('.required-value'), (index,val) ->
		required_value = parseFloat(val.getAttribute("data-required-value"))
		value = parseFloat(val.innerText)
		if value != required_value
			alert "Decisions must total 100% in order to be saved. Please adjust your decisions as necessary."
			value_good = false

	$.each $('.required-range'), (index,val) ->
		min = parseFloat(val.getAttribute("data-range-min"))
		max = parseFloat(val.getAttribute("data-range-max"))
		value = parseFloat(val.innerText)
		if value > max || value < min
			alert "Values must be in the range of 0 to 100. Please adjust your decision as necessary."
			value_good = false

	if value_good
		theHash = {
			round_id: 1,
			input_screen_id: 2,
			fields: [
			]
		}
		console.log("Going for the each")
		$.each $('.editable'), (index, val) ->
			console.log("Doing an Editable");
			console.log(val)
			theId = val.getAttribute("id")
			console.log(theId)
			theItem = {
				id: theId
				value: val.innerText
				input_item_id: val.getAttribute("input_item_id")
			}
			theHash['fields'].push(theItem)

		$.each $('.slider-input'), (index, val) ->
			console.log("Doing A Slider");
			console.log(val)
			theValue = val.getAttribute("value");
			id = "id"
			theItem = {
				id: id
				value: theValue
				input_item_id: val.getAttribute("input_item_id")
			}
			theHash['fields'].push(theItem)

		$.ajax({
			url: '/input_screen/update_decision',
			data: theHash,
			type: 'POST',
			dataType: 'json',
			success: (data) ->
				console.log("Got the Data back as")
				console.log(data)
				window.is_dirty = false
				$.toaster({priority: 'success', title: 'Data Saved', message: 'Your Data was saved successfully.'})
				if (url)
					setTimeout ( ->
						window.location = url
					), 1000
		});

jQuery ->
	$('.save-button').click (event) ->
		console.log("Got A Click - Save Button");
		save_data()
		console.log($(this))
		event.preventDefault()
