let NameToElementId = {
	job: "society-name",
	mafia: "society2-name",
	bank: "bank-account",
	vipdata: "vip-expire",
}

let bars = {}

let engineBar = null;
let speedBar = null;
let fuelBar = null;
let maxSpeed = 300;

$(function () {
	window.addEventListener('message', function (event) {
		let data = event.data.data;
		if (event.data.action == 'show') {
			$('#wrap').show();

		}
		else if (event.data.action == 'hide') {
			$('#wrap').hide();
		}
		else if (event.data.action == 'changePosition') {
			$('.bars').attr("id",event.data.position + "-bars");
		}
		else if (event.data.action == 'update'){
			let type = event.data.type;
			GetElementByType(type).html(data);
			switch (event.data.type) {
				case 'status': {
					$.each(data.status, function (index, value) {
						if (bars[index]) {
							bars[index].animate(value / 100);
						}
						else {
							console.log(index);
						}
					});

					break;
				}
				
			}
		}
		else if (event.data.action == 'updateBar'){
			let type = event.data.type;
			bars[type].animate(event.data.current/event.data.max);
		}
		else if (event.data.action == 'hideElement'){
			let type = event.data.type;
			GetElementByType(type).hide();
		}
		else if (event.data.action == 'showElement'){
			let type = event.data.type;
			GetElementByType(type).show();
		}
		else if (event.data.action == 'setWeaponImg'){
		    $('#weapon-img').css(`background-image`, `url(nui://rw_hud_i/html/img/items/` + data + `.png)`);
			$('#bottom-left-weapon').show();
		}
		else if (event.data.action == 'speedometer') {
			maxSpeed = data.maxSpeed;
			
			speedBar.animate(Math.round(data.speed) / 450);

			let health = Math.round(data.health / 1000 * 100)

			$('.engine-health').html(health);

			engineBar.animate({ engineBar: health }, {
				duration: 100,
				easing: "swing",
				step: function (p) {
					engineBar.css({
						transform: "rotate(" + (53 + (p * 0.65)) + "deg)",
					});
				}
			});

			let fuel = Math.round(data.fuel*1.55);

			if (fuel > 54) {
				document.querySelector('.fuel-icon').style.color = 'rgba(145,220,35,1)';
				document.querySelector('.fuel-bar').style.borderBottom = '0.5vw solid rgba(145,220,35,1)';
				document.querySelector('.fuel-bar').style.borderRight = '0.5vw solid rgba(145,220,35,1)';
			}
			else if (fuel > 40) {
				document.querySelector('.fuel-icon').style.color = 'rgba(255,225,30,1)';
				document.querySelector('.fuel-bar').style.borderBottom = '0.5vw solid rgba(255,225,30,1)';
				document.querySelector('.fuel-bar').style.borderRight = '0.5vw solid rgba(255,225,30,1)';
			}
			else if (fuel > 20) {
				document.querySelector('.fuel-icon').style.color = 'rgba(255,135,35,1)';
				document.querySelector('.fuel-bar').style.borderBottom = '0.5vw solid rgba(255,135,35,1)';
				document.querySelector('.fuel-bar').style.borderRight = '0.5vw solid rgba(255,135,35,1)';
			}
			else {
				document.querySelector('.fuel-icon').style.color = 'rgba(255,35,35,1)';
				document.querySelector('.fuel-bar').style.borderBottom = '0.5vw solid rgba(255,35,35,1)';
				document.querySelector('.fuel-bar').style.borderRight = '0.5vw solid rgba(255,35,35,1)';
			}

			$('.fuel').html(fuel);

			fuelBar.animate({ fuelBar: fuel }, {
				duration: 100,
				easing: "swing",
				step: function (p) {
					fuelBar.css({
						transform: "rotate(" + (41 + (p * 0.9)) + "deg)",
					});
				}
			});
		}
	});
});

function GetElementByType(type){
	if (NameToElementId[type]){
		return $('#'+NameToElementId[type])
	}
	else{
		return $('#'+type)
	}
}


document.addEventListener('DOMContentLoaded', function() {
	// Initialise progressbars
	bars.health = CreateProgBar('#healthbar',"<div id='healthbar-icon'><i class='fas fa-heartbeat'></i></div>");
	bars.vest = CreateProgBar('#vestbar',"<div id='vestbar-icon'><i class='fas fa-vest'></i></div>");
	bars.hunger = CreateProgBar('#hungrybar',"<div id='hungrybar-icon'><i class='fas fa-cheeseburger'></i></div>");
	bars.thirst = CreateProgBar('#thirstbar',"<div id='thirstbar-icon'><i class='fas fa-wine-glass-alt'></i></div>");
	bars.stamina = CreateProgBar('#staminabar',"<div id='staminabar-icon'><i class='fas fa-running'></i></div>");

}, false);

function CreateProgBar(element,img){
	let bar = new ProgressBar.Line(element, {
		strokeWidth: 4,
		strokeStyle: 'rgba(255,255,255,1)',
		fill: 'rgba(0,0,0,1)',
		trailColor: 'rgba(0,0,0,0.3)',
		trailWidth: 4,
		easing: 'easeInOut',
		duration: 1000,
		svgStyle: null,
		text: {
		  value: '',
		  alignToBottom: false
		},
		
	
		step: (state, bar) => {
		  bar.path.setAttribute('stroke', state.color);
		  bar.setText(img);
		  bar.text.style.color = state.color;
		}
	});
	return bar;
}
