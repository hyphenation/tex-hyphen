    $(document).ready(function(){
		$('div.section').hide();
		if (window.location.href.indexOf('#')==-1) {
			window.location.href += '#introduction';
		}
		nav = $('#navigation');
		links = '';
        $('h3').each(function(index){
			section = $(this).parents('div.section');
			text = $(this).text();
			name = section[0].id;
			$(this).html('<a name="'+name+'" href="#introduction" onClick="goHome">'+text+'</a>');
			links = links+'<a href="#'+name+'" onClick="handleClick(this,\''+name+'\')">'+text+'</a>';
			if (window.location.href.indexOf('#'+name)==-1) {
				section.hide();
			} else {
				section.show();
			}
		});
		nav.html(links);
		
		Hyphenator.config({
			displaytogglebox: true,
		});
		Hyphenator.addExceptions('de', 'Groß-va-ter');
		Hyphenator.run();
		
		$('#HyphenatorToggleBox').css('right:100px;');
    }); 
    
	function goHome() {
		$('#navigation a').show();
	}

	function handleClick(node, name) {
		$('#navigation a').show();
		/* $(node).hide(); */
		$('div.section').hide();
		$('div.section#'+name).show();
	}
	
	function LoadSample(selector) {
		if (selector.value.match(/(cs|de|en|fr|fi|pl)/i)) {
			$.get('sample-'+selector.value+'.html', {}, function(data){
				data = Hyphenator.hyphenate(data, selector.value);
				$('#demo_example').html(data);
			});
		} else if (selector.value=='--') {
			alert('Please select a language!');
		} else {
			alert('No fiddling with the code!');
		}
	}
	