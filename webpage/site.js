	$(document).ready(function(){
		$('div.section').hide();
		$('a,p,li,h3').each(function(index){
			html = $(this).html();
			text = $(this).text();
			if (html==text) {
				/* we don't want to replace TeX in link addresses! */
				$(this).html(html.replace(/TeX/g, 'T<sub class="tex">E</sub>X'));
			}
		});
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
	}); 
    
	function goHome() {
		$('#navigation a').show();
	}

	function handleClick(node, name) {
		$('#navigation a').show();
		/*$(node).hide();*/
		$('div.section').hide();
		$('div.section#'+name).show();
	}

