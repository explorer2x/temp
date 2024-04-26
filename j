function checkForDuplicatePlanTypes(employeeData) {
    const employeeIds = Object.keys(employeeData); // Get all employee IDs
    const results = {};

    employeeIds.forEach(employeeId => {
        const eeInfoArray = employeeData[employeeId].EEINFO;
        eeInfoArray.forEach(eeInfo => {
            const enrolledPlans = eeInfo.EE_BENEFIT["Enrolled Plans"];
            if (Array.isArray(enrolledPlans)) { // Check if enrolledPlans is an array
                const planTypes = enrolledPlans.map(plan => plan["Plan Type"]);
                const hasDuplicates = new Set(planTypes).size !== planTypes.length; // Check for duplicates

                results[employeeId] = hasDuplicates ? "Duplicate plan types found" : "No duplicates";
            } else {
                // Handle the case where enrolledPlans is not an array
                results[employeeId] = "Enrolled Plans is not an array or does not exist";
            }
        });
    });

    return results;
}

// Assuming employeeData is your JSON data structure
const employeeData = {
  // Your JSON data here...
};

console.log(checkForDuplicatePlanTypes(employeeData));



var allPageTags = new Array();

var allPageTags=document.getElementsByTagName("div");
for (i=0; i<allPageTags.length; i++)
if (allPageTags[i].className=='group-id') {
allPageTags[i].click();
}



var ev = new Event('input',{bubbles: true});ev.simulate = true;$0.value = '03/01/2023';$0.dispatchEvent(ev)




javascript: function delay(n) {
	return new Promise(function(resolve) {
		setTimeout(resolve, n * delay_second * 1000);
	});
}

async function get_event(ClientId, FromDate, ToDate) {
	await delay(2);
	const fetch_url = 'https://' + document.domain + '/benefits/Brokers/Wall/GetEventFeed';
	const data = {
		"filter": {
			"BrokerId": globals.b_id,
			"ClientId": ClientId,
			"FromDate": FromDate,
			"ToDate": ToDate,
			"IsTodo": true,
			"IsCompletedTodo": false,
			"WallItemTypeId": 2,
			"WallUserTypeId": 2,
		},
		"pagination": {}
	}
	try {
		console.log()
		const response = await fetch(fetch_url, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json; charset=UTF-8',
				'Accept': 'application/json, text/javascript, */*; q=0.01',
				'Entoken': token,
			},
			body: JSON.stringify(data)
		});
		const responseData = await response.json();
		return responseData;
	} catch (error) {
		console.error('Error:', error);
	}
}
async function get_client_id_list(fetch_url, feed_id) {
	await delay(1);
	const data = feed_id;
	try {
		const response = await fetch(fetch_url, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json; charset=utf-8',
				'Accept': 'application/json, text/javascript, */*; q=0.01',
				'Entoken': token,
				'Referer': 'https://' + document.domain + '/benefits/Brokers/Wall/'
			},
			body: data
		});
		const responseData = await response.json();
		return (responseData);
	} catch (error) {
		console.error('Error:', error);
	}
}

async function ChangeClient(url, data) {
	await delay(1);
	try {
		await fetch('https://' + document.domain + '/benefits/Resources/GenerateToken')
		await fetch('https://' + document.domain + '/benefits/brokers/')
		await delay(2);
		const response = await fetch(url, {
			method: 'POST',
			headers: {
				'Accept': "*/*",
				'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
				'Entoken': token
			},
			body: "s=" + data
		});
		const responseData = await response.text();
		return (responseData);
	} catch (error) {
		console.error('Error:', error);
	}
}

async function main_job() {
	var ee_ids = [];
	var ee_col = {};
	var walls = [];


	var incomplet = await get_client_id_list(incomp_url, 0);
	for (o = 0; o < incomplet.length; o++) {

		if (incomplet[o].InitialIncompleteItems != 0) {

			var BrokerClientId = incomplet[o].BrokerClientId;
			var ClientId = incomplet[o].ClientId;

			var Wall_detail = await get_event(ClientId, FromDate, ToDate);

			var broker_wall_events = Wall_detail.Directives.Listings;
			walls.push(broker_wall_events);
		}
		await delay(1);
	}


	for (o = 0; o < walls.length; o++) {
		var ct = 0;
		var broker_wall_events = walls[o];
		var res = [];
		for (p = 0; p < broker_wall_events.length; p++) {
			var client_id = broker_wall_events[p].ClientId;
			var broker_id = broker_wall_events[p].BrokerId;
			var emp_ID = broker_wall_events[p].EmpId;
			if (!ee_ids.includes(emp_ID)) {
				ee_ids.push(emp_ID);
				if (ct == 0) {

					var ChangeEmployeePostJson_url = 'https://' + document.domain + '/benefits/Brokers/Session/ChangeClient';

					await ChangeClient(ChangeEmployeePostJson_url, client_id)

					ct = ct + 1;
				}
				var ee_info = await get_ee_job(emp_ID);
			} else {
				var ee_info = [];
			}

			const result = {
				ClientName: broker_wall_events[p].ClientName,
				CreatedDate: broker_wall_events[p].CreatedDate,
				Reason: broker_wall_events[p].Reason,
				EmpId: broker_wall_events[p].EmpId,
				Feed: broker_wall_events[p].Feed,
				EmployeeName: broker_wall_events[p].EmployeeName,
			};
			if (!(emp_ID in ee_col)) {
				var temp_c = {};
				var temp_res = [];
				temp_c['EEINFO'] = ee_info;
				temp_res.push(result);
				temp_c['Wall'] = temp_res;
				ee_col[emp_ID] = temp_c;
			} else {
				ee_col[emp_ID]['Wall'].push(result);
			}
		}

	}

	const textContent = '[' + JSON.stringify(ee_col) + ']';
	const textarea = document.createElement('textarea');
	textarea.id = "myres";
	textarea.value = textContent;
	document.body.appendChild(textarea);
	var sameElement = document.getElementById("myres");
	console.log(sameElement);
	console.log("Length of textContent:", sameElement.value.length);
}

async function change_company(url, data) {
	await delay(1);
	try {
		const response = await fetch(url, {
			method: 'POST',
			headers: {
				'Accept': "application/json, text/javascript, */*; q=0.01",
				'Content-Type': 'application/json',
				'Entoken': token
			},
			body: JSON.stringify(data)
		});
		const responseData = await response.text();
		return (responseData);
	} catch (error) {
		console.error('Error:', error);
	}
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


async function get_ee_job(ee_id) {
	const ee_res = [];
	var datasheet = await get_datasheet(ee_id);
	var ee_email = await get_email(ee_id);
	var ee_phone = await get_phone(ee_id);
	var ee_benefit = await get_benefit(ee_id);
	var ee_timeline = await get_timeline(ee_id);
	var ee_plans = await get_plans(ee_id);
	var ee_depts = [];
	var ee_info =[];
	var ee_address = [];
	var ee_CafeEnrollments = [];
	var ee_Enrollments = [];
	var ee_EnrollmentChanges = [];

	if (datasheet) {
		if (datasheet.EmployeeData && datasheet.EmployeeData.Table) {
			var ee_info = datasheet.EmployeeData.Table;
		}
		if (datasheet.Dependents && datasheet.Dependents.Table) {
			var ee_depts = datasheet.Dependents.Table;
		}
		if (datasheet.EmployeeAddresses && datasheet.EmployeeAddresses.Table) {
			var ee_address = datasheet.EmployeeAddresses.Table;
		}
		if (datasheet.Enrollments && datasheet.Enrollments) {
			var ee_Enrollments = datasheet.Enrollments;
		}
		if (datasheet.EnrollmentChanges && datasheet.EnrollmentChanges) {
			var ee_EnrollmentChanges = datasheet.EnrollmentChanges;
		}
		if (datasheet.CafeEnrollments && datasheet.CafeEnrollments) {
			var ee_CafeEnrollments = datasheet.CafeEnrollments;
		}
	} else {
		console.error("Datasheet data not found");
	}

	const result = {
		EE_INFO: ee_info,
		EE_DEPT: ee_depts,
		EE_ADDRESS: ee_address,
		EE_EMAIL: ee_email,
		EE_PHONE: ee_phone,
		EE_CAFE: ee_CafeEnrollments,
		EE_ENROLLMENT: ee_Enrollments,
		EE_ENCHANGE: ee_EnrollmentChanges,
		EE_BENEFIT: ee_benefit,
		EE_PLANS: ee_plans,
		EE_TIMELINE: ee_timeline
	};
	ee_res.push(result);
	return ee_res



	async function get_datasheet(ee_id) {
		const html_var = await get_call('https://' + document.domain + '/benefits/Hris/Employee/DataSheet?empId=' + ee_id, ee_id);
		const eventsData = parse_datasheet(html_var);
		return await eventsData;

		function parse_datasheet(html) {
			var parser = new DOMParser();
			var doc = parser.parseFromString(html, 'text/html');
			var scripts = Array.from(doc.querySelectorAll('script'));
			var scriptTag = scripts.find(script => script.textContent.includes('var model = {'));
			var eventsData;
			var scriptContent = scriptTag.textContent;
			var eventsRegex = /model = \s*([\s\S]*?\;)/;
			var matches = eventsRegex.exec(scriptContent);
			if (matches && matches[1]) {
				if (matches[1].endsWith(";")) {
					modifiedString = matches[1].slice(0, -1);
				} else {
					modifiedString = matches[1];
				}
				eventsData = JSON.parse(modifiedString);
			}
			return eventsData
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

				// Define arrays for work and personal phone identifiers
				const workIdentifiers = ["work", "business", "main"];
				const personalIdentifiers = ["personal", "private", "home"];

				if (workIdentifiers.some(identifier => type.includes(identifier))) {
					Work_Phone = number.replace(/\D/g, "");
				} else if (personalIdentifiers.some(identifier => type.includes(identifier))) {
					Personal_Phone = number.replace(/\D/g, "");
				}


			});


			return {
				"Work Phone": Work_Phone,
				"Home Phone": Personal_Phone
			}
		}

	}

	async function get_email(ee_id) {
		const html_var = await get_call('https://' + document.domain + '/employee/Profile/Email?empId=' + ee_id);

		const eventsData = parse_email_htmldata(html_var);
		return eventsData;

		function parse_email_htmldata(html) {
			var parser = new DOMParser();
			var doc = parser.parseFromString(html, 'text/html');

			const workEmailInput = doc.querySelector("#WorkEmail");
			const personalEmailInput = doc.querySelector("#PersonalEmail");
			const selectElement = doc.getElementById('LkpPrimaryEmailTypeId');

			const Work_Email = workEmailInput ? workEmailInput.value : "";
			const Personal_Email = personalEmailInput ? personalEmailInput.value : "";
			const Primary_Email_type = selectElement ? selectElement.options[selectElement.selectedIndex].text : "";

			return {
				"Work Email": Work_Email,
				"Personal Email": Personal_Email,
				"Primary Email Type": Primary_Email_type
			}

		}
	}

	async function get_benefit(ee_id) {
		const html_var = await get_call('https://' + document.domain + '/benefits/Hris/Employee/BenefitsSummary?empId=' + ee_id);
		const eventsData = parse_benefit_htmldata(html_var);
		return eventsData;

		function parse_benefit_htmldata(html) {

			var parser = new DOMParser();
			var doc = parser.parseFromString(html, 'text/html');

			const tgt_title = ['Enrolled Plans', 'Dependents', 'Declined Coverage', 'Cafeteria Plans', 'Ended Coverage'];
			const allPageTags = doc.getElementsByTagName("h3");
			let results = {};

			for (let i = 0; i < allPageTags.length; i++) {
				if (allPageTags[i].className == 'margin-top') {
					const titleText = allPageTags[i].textContent;
					if (tgt_title.includes(titleText)) {

						const tb = allPageTags[i].nextElementSibling;
						// Check if it's the 'Enrolled Plans' section and the next element is an 'h4'
						if (titleText === 'Enrolled Plans' && tb.tagName.toLowerCase() === 'h4' && tb.textContent.trim() === 'Not Enrolled In Any Plans') {
							results[titleText] = 'Not Enrolled In Any Plans';
						} else {
							// Proceed as before if it is a table or any other title
							const tbdata = handle_tb(tb);
							results[titleText] = tbdata;
						}
					};
				}
			}

			function handle_tb(tb) {
				const headers = Array.from(tb.querySelectorAll('th')).map(header => header.textContent.trim());

				const data = Array.from(tb.querySelectorAll('tbody tr')).map(row => {
					const cells = Array.from(row.querySelectorAll('td')).map(cell => {
						const divs = cell.querySelectorAll('div');
						if (divs.length > 0) {
							return Array.from(divs).map(div => div.textContent.trim());
						} else {
							return cell.textContent.trim();
						}
					});

					let obj = {};
					cells.forEach((cell, index) => {
						if (cell) { // This check ensures only non-empty cells are added
							obj[headers[index]] = cell;
						}
					});

					return obj;
				}).filter(obj => Object.keys(obj).length > 0); // Filter out any empty objects

				return data;
			}

			return results;
		}
	}


	async function get_timeline(ee_id) {
		const html_var = await get_call('https://' + document.domain + '/benefits/Hris/Employee/Timeline?empId=' + ee_id);
		const eventsData = parse_timeline(html_var);
		return await eventsData;

		function parse_timeline(html) {
			var parser = new DOMParser();
			var doc = parser.parseFromString(html, 'text/html');
			var scriptTags = doc.querySelectorAll('script[type="text/javascript"]');
			var eventsData;
			for (var i = 0; i < scriptTags.length; i++) {
				var scriptContent = scriptTags[i].textContent;
				var eventsRegex = /events:\s*([\s\S]*?\}\]),/;
				var matches = eventsRegex.exec(scriptContent);

				if (matches && matches[1]) {
					eventsData = JSON.parse(matches[1]);
					break;
				}
			}
			return eventsData
		}
	}


	async function get_plans(ee_id) {
		const html_var = await get_call('https://' + document.domain + '/employee/Benefits/Overview?empId=' + ee_id);
		const eventsData = parse_plan_htmldata(html_var);
		return eventsData;

		function parse_plan_htmldata(html) {
			let results = {};
			const parser = new DOMParser();
			const doc = parser.parseFromString(html, 'text/html');


			const allh2Tags = doc.getElementsByTagName("h2");

			for (u = 0; u < allh2Tags.length; u++) {

				if (allh2Tags[u].textContent.trim() == 'Benefits Overview') {

					const mainel = allh2Tags[u].nextElementSibling

					const allPageTags = mainel.getElementsByTagName("table");

					for (i = 0; i < allPageTags.length; i++) {
						const tb = allPageTags[i]
						for (o = 1; o < tb.rows.length; o++) {
							results[tb.rows[o].cells[0].textContent.trim()] = tb.rows[o].cells[1].textContent.trim();
						}
					}
				}
			}

			return results;
		}
	}




}
async function job() {
	await main_job()

};
const processeditem = [];
var get_client_url = 'https://' + document.domain + '/benefits/Brokers/Wall/GetIncompleteClientItems';
var broker_wall_url = 'https://' + document.domain + '/benefits/Brokers/Wall/BrokerWall';
var incomp_url = 'https://' + document.domain + '/benefits/Brokers/Wall/GetIncompleteClientItems';
var scriptTags = document.getElementsByTagName('script');
var token = null;
var tokenRegex = /var token = '([A-F0-9]+)';/;
for (var i = 0; i < scriptTags.length; i++) {
	var scriptContent = scriptTags[i].textContent || scriptTags[i].innerHTML;
	var match = tokenRegex.exec(scriptContent);
	if (match) {
		token = match[1];
		break;
	}
}
var delay_second = 0.5;

var daysAgo = 5;
var FromDate = new Date(Date.now() - daysAgo * 24 * 60 * 60 * 1000).toLocaleDateString('en-US');
var ToDate = new Date().toLocaleDateString('en-US');

job()
