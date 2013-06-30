nyanz.landing = ->
	submitZip = $('#get-weather')
	zipIn = $('#zip-code')
	weatherOutput = $('#weather-out')
	dayStrings = ['tomorrow', 'day after tomorrow', 'day after that', 'today + 4 days']
	isLoading = false
	loaderIcon = $('.loader')
	errText = $('#error-text')

	zipIn.keyup (e) ->
		if e.which == 13
			submitZip.click()

	submitZip.keyup (e) -> submitZipData() if e.which == 13

	submitZip.click -> submitZipData()

	submitZipData = ->
		zipCode = zipIn.val()
		errText.fadeOut()

		if zipCode.length == 5
			isLoading = true
			loaderIcon.show()
			destURL = 'http://api.worldweatheronline.com/free/v1/weather.ashx?q=' + zipCode + '&format=json&num_of_days=5&key=mjdut3p7jcgm2u5c7wbbc438'

			$.ajax
				url: destURL
				type: 'GET'
				dataType: 'jsonp'
				success: (data) ->
					console.log data
					if data.data.error
						showError(data.data.error[0].msg)
					else
						showWeather(data)
				error: (data) ->
					console.log data
				complete: ->
					loaderIcon.hide()

	showError = (data) ->
		errMsg = data
		weatherOutput.fadeOut()
		errText.children('p').text(errMsg)
		newHeight = 15 + parseInt(errMsg.length / 40) * 18
		console.log errMsg.length + ',' + newHeight


		errText.css({ 'height': newHeight }).fadeIn()
		
	showWeather = (data) ->
		rightNow = data.data.current_condition[0]
		nextDays = data.data.weather
		nextDays = nextDays.splice(1, nextDays.length)
		currString = ""
		

		todayDiv = $('.weather-container', '.today')
		currString += "<li class='desc'>" + rightNow.weatherDesc[0].value + getWeatherIcon(rightNow.weatherDesc[0].value) + "</li>"
		currString += "<li class='temp'>temp:\t" + rightNow.temp_F + "<span class='temp-text'>+</span>/" + rightNow.temp_C + "<span class='temp-text'>*</span></li>"
		currString += "<li class='humidity'>humidity:\t" + rightNow.humidity + "</li>"
		currString += "<li class='winddir-16Point'>wind direction:\t" + rightNow.winddir16Point + "</li>"
		currString += "<li class='windspeedmiles'>wind speed:\t" + rightNow.windspeedMiles + "</li>"

		todayDiv.html('').append(currString)

		$('.day:not(.today)').html('')

		for i in [0..nextDays.length - 1]
			currString = "<h3 class='time'>" + dayStrings[i] + "</h3>"
			currString += "<ul class='weather-container'>"
			thisDay = nextDays[i]

			currString += "<li class='desc'>" + thisDay.weatherDesc[0].value + getWeatherIcon(thisDay.weatherDesc[0].value) + "</li>"
			currString += "<li class='max'>max:\t" + thisDay.tempMaxF + "<span class='temp-text'>+</span>/" + thisDay.tempMaxC + "<span class='temp-text'>*</span></li>"
			currString += "<li class='min'>min:\t" + thisDay.tempMinF + "<span class='temp-text'>+</span>/" + thisDay.tempMinC + "<span class='temp-text'>*</span></li>"
			currString += "<li class='winddir-16Point'>wind direction:\t" + thisDay.winddir16Point + "</li>"	
			currString += "<li class='windspeedmiles'>wind speed:\t" + thisDay.windspeedMiles + "mph</li>"	

			currString += "</ul>"

			$('.day.day' + i).append(currString)

		weatherOutput.fadeIn()
		$('html, body').animate({
			scrollTop: $(weatherOutput).offset().top
		}, 2000);

		#scroll to elem
		$('html, body').animate({
	        scrollTop: $(weatherOutput).offset().top
	    }, 2000);

	getWeatherIcon = (desc) ->
		desc = desc.replace(/\s/g, '')
		icon = eval('window.descToIcon.' + desc)
		if icon is undefined
			return " "
		else
			iconString = "<span class='temp-text bigger-small-text'>"
			iconString += icon
			iconString += "</span>"
			
			return iconString

