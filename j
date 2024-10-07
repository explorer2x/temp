


javascript: function delay(n) {
	return new Promise(function(resolve) {
		setTimeout(resolve, n * delay_second * 300);
	});
}

async function get_event(ClientId, FromDate, ToDate,LastId) {
	await delay(1);
	const fetch_url = 'https://' + document.domain + '/benefits/Licensees/Wall/GetEventFeed';
	const data = {
		"filter": {
			"BrokerId": globals.b_id,
			"ClientId": ClientId,
			"FromDate": FromDate,
			"ToDate": ToDate,
			//"IsTodo": true,
			//"IsCompletedTodo": false,
			"WallItemTypeId": 2,
			"WallUserTypeId": 1,
		},
		"pagination": {"LastId": LastId}
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
				'Referer': 'https://' + document.domain + '/benefits/Licensees/Wall/'
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
		await fetch('https://' + document.domain + '/benefits/Licensees/')

        const jsonData = JSON.stringify(data);
        await delay(2);
		const response = await fetch(url, {
			method: 'POST',
			headers: {
				'Accept': "application/json, text/javascript, */*; q=0.01",
				'Content-Type': 'application/json; charset=UTF-8',
				'Entoken': token,
				'referer': 'https://' + document.domain + '/benefits/Licensees/Wall/'
			},
			body: jsonData
		});
		const responseData = await response.text();
		return (responseData);
	} catch (error) {
		console.error('Error:', error);
	}
}



async function main_job() {
    
    
    async function fetchListings(clientId, fromDate, toDate, startId = 0) {
        let listings = [];
        let lastId;

      
        const result = await get_event(clientId, fromDate, toDate, startId);
        if (result.Directives && result.Directives.Listings) {
            listings = result.Directives.Listings;
            if (listings.length === 250) {
                lastId = listings[listings.length - 1].Id;
                const additionalListings = await fetchListings(clientId, fromDate, toDate, lastId);
                listings = listings.concat(additionalListings);
            }
        }

        return listings;
    }
    
	var ee_ids = [];
	var ee_col = {};
	var walls = [];


	var incomplet = await get_client_id_list(incomp_url, 0);
	for (var o = 0; o < incomplet.length; o++) {

		if (incomplet[o].InitialIncompleteItems != 0) {

			var BrokerClientId = incomplet[o].BrokerClientId;
			var ClientId = incomplet[o].ClientId;

		    var Wall_detail = await fetchListings(ClientId, FromDate, ToDate);
			walls.push(Wall_detail);
			await delay(1);
		}
	}

	for (var o = 0; o < walls.length; o++) {
		var ct = 0;
		var broker_wall_events = walls[o];
		var res = [];
		for (p = 0; p < broker_wall_events.length; p++) {
			var result = {};
			var client_id = broker_wall_events[p].ClientId;
			var broker_id = broker_wall_events[p].BrokerId;
			var emp_ID = broker_wall_events[p].EmpId;
			if (!ee_ids.includes(emp_ID)) {
				ee_ids.push(emp_ID);
				if (ct == 0) {
					var ChangeEmployeePostJson_url = 'https://' + document.domain + '/benefits/Licensees/Session/ChangeClient';
					var ChangeEmployeePostJson_url = 'https://' + document.domain + '/benefits/Licensees/Session/ChangeClientPostJson';
					
					var combinedString= `${client_id},${broker_id}`;
					await ChangeClient(ChangeEmployeePostJson_url, {"s": combinedString})
					ct = ct + 1;
				}
				var ee_info = await get_ee_job(emp_ID);
			} else {
				var ee_info = [];
			}

			var result = {
				ClientName: broker_wall_events[p].ClientName,
				CreatedDate: broker_wall_events[p].CreatedDate,
				Reason: broker_wall_events[p].Reason,
				EmpId: broker_wall_events[p].EmpId,
				Feed: broker_wall_events[p].Feed,
				EmployeeName: broker_wall_events[p].EmployeeName,
				WallID: broker_wall_events[p].Id
			};


			if ((emp_ID in ee_col)) {

				ee_col[emp_ID]['Wall'].push(result);

			} else if (!(emp_ID in ee_col)) {

				var temp_c = {};
				var temp_res = [];
				temp_c['EEINFO'] = ee_info;
				temp_res.push(result);
				temp_c['Wall'] = temp_res;
				ee_col[emp_ID] = temp_c;

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
	var ee_Contact = await get_Contact(ee_id);
	//var ee_benefit = await get_benefit(ee_id);
	var ee_timeline = await get_timeline(ee_id);
	var ee_plans = await get_plans(ee_id);
	var ee_benefitsummary_Current = await get_BS_Current(ee_id);
	var ee_benefitsummary_OE = await get_BS_OE(ee_id);
	var ee_benefitsummary_History = await get_BS_History(ee_id);
	var ee_benefitsummary_PendingPeriod = await get_BS_Pending(ee_id);

	var ee_depts = [];
	var dept_enrollments = [];
	var ee_info = [];
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
		if (datasheet.Enrollments) {
			var ee_Enrollments = datasheet.Enrollments;
		}
		if (datasheet.EnrollmentChanges) {
			var ee_EnrollmentChanges = datasheet.EnrollmentChanges;
		}
		if (datasheet.CafeEnrollments) {
			var ee_CafeEnrollments = datasheet.CafeEnrollments;
		}
		if (datasheet.DependentEnrollments) {
			var dept_enrollments = datasheet.DependentEnrollments;
		}
	} else {
		console.error("Datasheet data not found");
	}

	const result = {
		EmployeeDataSheet_EmployeeReview: ee_info,
		EmployeeDataSheet_Dependents: ee_depts,
		EmployeeDataSheet_EmployeeAddresses: ee_address,
		Profile_Contact: ee_Contact,
		EmployeeDataSheet_CafeteriaEnrollments: ee_CafeEnrollments,
		EmployeeDataSheet_Enrollments: ee_Enrollments,
		EmployeeDataSheet_EnrollmentChanges: ee_EnrollmentChanges,
		BenefitsSummary_Current: ee_benefitsummary_Current,
		BenefitsSummary_OpenEnrollment: ee_benefitsummary_OE,
		BenefitsSummary_PendingPeriod: ee_benefitsummary_PendingPeriod,
		BenefitsSummary_History: ee_benefitsummary_History,
		Plans: ee_plans,
		Timeline: ee_timeline,
		EmployeeDataSheet_DependentEnrollments: dept_enrollments
	};
	ee_res.push(result);
	return ee_res

	async function get_datasheet(eeid) {

		const html_var = await get_call('https://' + document.domain + '/benefits/Hris/Employee/DataSheet?empId=' + ee_id, ee_id);
		var parser = new DOMParser();
		var doc = parser.parseFromString(html_var, 'text/html');
		var scriptTags = doc.getElementsByTagName('script');
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

		var fetch_url = 'https://' + document.domain + '/benefits/Hris/Employee/UpdateDataSheet?empId=' + eeid;
		data = {
			"empId": eeid,
			"enrollmentFilters": ["'current'", "'pending'", "'prior'", "'canceled'", "'removed'", "'open'"],
			"depEnrollmentFilters": ["'current'", "'pending'", "'open'", "'prior'", "'removed'", "'canceled'"]
		}

		try {
			const response = await fetch(fetch_url, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
					'Accept': '*/*',
					'Entoken': token,
					'Referer': 'https://' + document.domain + '/benefits/Hris/Employee/DataSheet?empId=' + eeid,
				},
				body: JSON.stringify(data)
			});
			const responseData = await response.json();
			return (responseData.Directives.DataSheetModel);
		} catch (error) {
			console.error('Error:', error);
		}

	}

	async function get_Contact(ee_id) {
		const html_var = await get_call('https://' + document.domain + '/benefits/Hris/Manage/Contact?empId=' + ee_id);
		const eventsData = parse_phone_htmldata(html_var);
		return eventsData;

		function parse_phone_htmldata(html) {
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

			const HomePhone = eventsData.Data.PhoneHome;
			const MobilePhone = eventsData.Data.PhoneMobile;
			const WorkPhone = eventsData.Data.PhoneWork;
			const WorkPhoneExt = eventsData.Data.PhoneWorkExt;
			const PersonalEmail = eventsData.Data.PersonalEmail;
			const WorkEmail = eventsData.Data.WorkEmail;
			const LkpPrimaryEmailType = convertEmailTypeId(eventsData)

			return {
				"Home Phone": HomePhone,
				"Mobile Phone": MobilePhone,
				"Work Phone": WorkPhone,
				"Work Phone Ext": WorkPhoneExt,
				"Work Email": WorkEmail,
				"Personal Email": PersonalEmail,
				"Primary Email Type": LkpPrimaryEmailType
			}

			function convertEmailTypeId(data) {
				const typeId = data.Data.LkpPrimaryEmailTypeId;
				if (!typeId) {
					return 'Unknown';
				}
				const lookupTable = data.Tables.LkpPrimaryEmailTypeId;
				const label = lookupTable.find(entry => entry.Value === typeId.toString());
				return label ? label.Label : 'Unknown';
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

	async function get_BS_Current(ee_id) {
		const html_var = await get_call('https://www.employeenavigator.com/benefits/Hris/Employee/SummaryPartial?empId=' + ee_id + '&typeId=1');
		var eventsData = parse_Current_OE(html_var)
		return eventsData;
	}

	async function get_BS_OE(ee_id) {
		const html_var = await get_call('https://www.employeenavigator.com/benefits/Hris/Employee/SummaryPartial?empId=' + ee_id + '&typeId=2');
		var eventsData = parse_Current_OE(html_var)
		return eventsData;
	}

	async function get_BS_Pending(ee_id) {
		const html_var = await get_call('https://www.employeenavigator.com/benefits/Hris/Employee/SummaryPartial?empId=' + ee_id + '&typeId=5');
		var eventsData = parse_Current_OE(html_var)
		return eventsData;
	}

	async function get_BS_History(ee_id) {
		const html_var = await get_call('https://www.employeenavigator.com/benefits/Hris/Employee/SummaryPartial?empId=' + ee_id + '&typeId=4');
		var eventsData = parse_History(html_var)
		return eventsData;
	}

	function parse_Current_OE(html_var) {
		const jsonResult = {};

		var parser = new DOMParser();
		var doc = parser.parseFromString(html_var, 'text/html');
		const headings = doc.querySelectorAll(".summary h3");

		headings.forEach(heading => {
			const tableName = heading.textContent.trim().replace(/\n+/g, ''); // Get the title of each section
			let contentElement = heading.nextElementSibling; // The element immediately following the heading

			if (contentElement.tagName === "TABLE") {
				let rows = contentElement.querySelectorAll("tr:not(:first-child)");
				let data = Array.from(rows).map(row => {
					const cells = row.querySelectorAll("td");
					let rowData = {};
					Array.from(contentElement.querySelectorAll("th")).forEach((th, index) => {
						let cleanedHeaderText = th.textContent.trim().replace(/\n+/g, ''); // Remove newlines
						if (cleanedHeaderText === "Plan Types" && cells[index]) {
							// Special handling for Plan Types, split by newlines and trim each entry
							rowData[cleanedHeaderText] = cells[index].querySelectorAll("div").length > 0 ?
								Array.from(cells[index].querySelectorAll("div")).map(div => div.textContent.trim()) :
								cells[index].textContent.split(/\n+/).map(s => s.trim()).filter(Boolean);
						} else {
							rowData[cleanedHeaderText] = cells[index] ? cells[index].textContent.trim() : "";
						}
					});
					return rowData;
				});

				jsonResult[tableName] = data;
			} else if (contentElement.tagName === "H4" && contentElement.classList.contains("margin-top")) {
				// Store the 'Not Enrolled In Any Plans' message
				jsonResult['Plan Type'] = contentElement.textContent.trim();
			}
		});

		return jsonResult;
	}

	function parse_History(html_var) {
		const jsonResult = [];

		var parser = new DOMParser();
		var doc = parser.parseFromString(html_var, 'text/html');
		const headings = doc.querySelectorAll(".summary h3");

		const tables = doc.querySelectorAll("table");

		if (tables.length === 0) {
			// Directly add the 'No coverages to show' message to jsonResult if no tables are found
			jsonResult.push({ "Coverages": "No coverages to show" });
			return jsonResult
		} else {

			tables.forEach(table => {
				let currentCategory = ""; // To store the current category as we iterate through rows
				const rows = table.querySelectorAll("tr");

				rows.forEach(row => {
					// Check if the row is a category header

					if (row.querySelector("h4")) {
						currentCategory = row.querySelector("h4").textContent.trim(); // Update current category
					} else {
						// Process normal data rows under the current category
						const cells = row.querySelectorAll("td");
						if (cells.length > 0) { // Ensure it's a data-containing row
							let rowData = {};
							rowData['Coverages'] = currentCategory;
							Array.from(table.querySelectorAll("th")).forEach((th, index) => {
								rowData[th.textContent.trim()] = cells[index] ? cells[index].textContent.trim() : "";
							});
							if (currentCategory) {
								jsonResult.push(rowData); // Add data to the current category
							}
						}
					}
				});
			});

			return jsonResult

		}
	}
}

async function job() {
	await main_job()

};
const processeditem = [];
var get_client_url = 'https://' + document.domain + '/benefits/Licensees/Wall/GetIncompleteClientItems';
var broker_wall_url = 'https://' + document.domain + '/benefits/Licensees/Wall/BrokerWall';
var incomp_url = 'https://' + document.domain + '/benefits/Licensees/Wall/GetIncompleteClientItems';

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

var daysAgo = 0;
var FromDate = new Date(Date.now() - daysAgo * 24 * 60 * 60 * 1000).toLocaleDateString('en-US');
var ToDate = new Date().toLocaleDateString('en-US');

job()
