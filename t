function delay(n) {
	return new Promise(function(resolve) {
		setTimeout(resolve, n * 1 * 1000);
	});
}
async function get_call(url, uid) {
	await delay(1);
	console.log('now fetching ' + url);
	try {
		var response = await fetch(url, {
			headers: {
				'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
				'Referer': 'https://' + document.domain + '/benefits/Hris/Employee/Manage?empId=' + uid
			}
		});
		if (!response.ok) {
			throw new Error('Network response was not ok');
		}
		console.log('fetch finished');
		return await response.text();
	} catch (error) {
		console.error('There was a problem with the fetch operation:', error);
	}
}

async function get_phone(ee_id) {
		const html_var = await get_call('https://' + document.domain + '/employee/Profile/Phone?empId=' + ee_id);

		const eventsData = parse_phone_htmldata(html_var);
		return eventsData;

		function parse_phone_htmldata(html) {
			var parser = new DOMParser();
			var doc = parser.parseFromString(html, 'text/html');

			const tableRows = doc.querySelectorAll(".table.table-striped tbody .en-list-item");

			let Work_Phone = "",
				Personal_Phone = "";

			Array.from(tableRows).forEach(row => {
				const typeCell = row.querySelector("td:nth-child(2)");
				const numberCell = row.querySelector("td:nth-child(3)");

				const type = typeCell ? typeCell.textContent.trim().toLowerCase() : "";
				const number = numberCell ? numberCell.textContent.trim() : "";

				if (type.includes("work")) {
					Work_Phone = number;
				} else if (type.includes("personal")) {
					Personal_Phone = number;
				}

			});


			return {
				"Work Phone": Work_Phone,
				"Personal Phone": Personal_Phone
			}
		}

	}

async function mainjob() {
	ress = await get_phone('1003207');
	console.log(ress)
}
mainjob()
