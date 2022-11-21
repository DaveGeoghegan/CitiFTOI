jQuery ->
	console.log("App Coffee")

jQuery ->
	$('.xxreport-menu-item').click (event) ->
		the_team_round_id = $(this)[0].getAttribute('data-team-round-id')
		theUrl = "/team/reports/" + the_team_round_id
		window.open  theUrl , "_blank"