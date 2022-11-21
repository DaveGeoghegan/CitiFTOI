# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
	$('.round-button-group').on 'click', '.start-round', (event) ->
		console.log("Got A Click");
		console.log($(this))
		the_round_id = $(this)[0].getAttribute('data-team-round-id')
		console.log(the_round_id)
		the_url = '/round/' + the_round_id
		window.location = the_url
		event.preventDefault()

jQuery ->
	$(".progress-bar").each (idx,val) ->
		console.log("Processing a Progress Bar")
		console.log(val)
		amount = parseInt(val.getAttribute('data-progress'))
		console.log("Amount is ")
		console.log(amount)
		$(val).progressbar({
				value: amount ,
			});

jQuery ->
	$(".starxt-round").click (event) ->
		console.log("Clicked the Start Round Button")
		console.log($(this)[0])
		theEl = $(this)[0]
		theEl = $(theEl)
		round_id = theEl.getAttribute("data-round-id")
		console.log("Round id " + round_id )

jQuery ->
	$('.input-screen-selections').on 'click', '.input-screen-button', (event) ->
		console.log("Got A Click");
		console.log($(this))
		the_screen_id = $(this)[0].getAttribute('data-input-screen-id')
		console.log(the_round_id)
		the_round_id = $(this)[0].getAttribute('data-team-round-id')
		the_url = '/round/' + the_round_id+ '/input_screen/' + the_screen_id
		window.location = the_url
		event.preventDefault()