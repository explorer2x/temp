
var jsonObject = {
  "Search Criteria": {
    "AccountID": "160157"
  },
  "Employee Search": {
    "Find an Employee/Dependent": "Employee",
    "SSN": "123456780",
    "Last Name": "FUENTES",
    "First Name": "FUENTES",
    "DOB": "08/29/1987"
  },
  "General Info": {
    "Enrollment Start Date": "04/01/2024",
    "Type of Enrollment:": "Initial",
    "Event Reason": "NewHire",
    "HIPPA Certification:": "No",
    "Other Insurance:": "Unknown ",
    "Changed On": "04/23/2024",
    "First Name": "AMELIA",
    "Last Name": "FUENTES",
    "Gender": "Female",
    "SSN": "123456780",
    "DOB": "08/29/1987",
    "Married": "Unknown",
    "Hire_Date": "05/18/2023",
    "Status:": "Active",
    "Age When Enrollment Start (Enrollment Start Date - DOB )": "Unknown",
    "Native Language:": "English",
    "Preferred Written Language:": "English",
    "Preferred Spoken Language:": "English",
    "Race/Ethnicity": "Unknown",
    "Country": "United States",
    "Address1": "123 AVE APT 2A",
    "City": "Chicago",
    "State": "IL",
    "Zip": "606382860",
    "Home Phone": "7081234567",
    "Primary Email": "123@321.net"
  },
  "Employee Info": {
    "CMS Employee Status Code:": "A - Active",
    "*Actively Employed:": "Yes",
    "Sub CDHP Elections:": "*Pls. manually handle, If the group have the field in BCBS - out of automationin phase 1"
  },
  "Coverage Info": {
    "Plan Name - Medical": "BLUE OPTIONS",
    "Product - Medical": "0007 G506OPT",
    "Coverage Level - Medical": "Y",
    "PCP (Medical)": "No",
    "PCP (OBGYN)": "No",
    "*Dental Clinic Number:": "*Pls. manually handle, If the group have the field in BCBS - out of automationin phase 1"
  },
  "Depebdent Summary": {
    "Last Name": "Dook|Fook",
    "First Name": "AA|BB",
    "Middle": " | ",
    "Relationship": "Dependent Child|Dependent Child",
    "Gender": "Female|Male",
    "DOB": "10/20/2011|08/06/2007",
    "SSN": "123456781|123456782",
    "Native Language:": "English|English",
    "Preferred Written Language:": "English|English",
    "Preferred Spoken Language:": "English|English",
    "Ethnicity (select all that apply):": "Unknown|Unknown",
    "Race (select all that apply):": "Unknown|Unknown",
    "Medicare Eligible": "No|No",
    "Different address information than the employee?": "No|No"
  }
}

function input_refresh(tgt_elg, val) {
	tgt_elg.dispatchEvent(new Event('focusin'));
	tgt_elg.value = val;
	tgt_elg.dispatchEvent(new Event('input'));
	tgt_elg.dispatchEvent(new Event('change'));
	tgt_elg.dispatchEvent(new Event('blur'));
	tgt_elg.dispatchEvent(new Event('focusout'));
};


input_refresh(document.querySelector("#searchAcctNumber"), jsonObject['Search Criteria']['AccountID'])



var allPageTags = document.getElementsByTagName("a");
for (i = 0; i < allPageTags.length; i++) {
	if (allPageTags[i].textContent == 'Find') {
		allPageTags[i].click();
		break;
	}
}


//--------------------------will refresh, need invoke below in next PAD element

if (document.querySelector("#searchResults").rows.length == 2) {
	document.querySelector("#searchResults").rows[1].cells[0].firstChild.click()
}




//=============================page2=========================================



function input_refresh(tgt_elg, val) {
	tgt_elg.dispatchEvent(new Event('focusin'));
	tgt_elg.value = val;
	tgt_elg.dispatchEvent(new Event('input'));
	tgt_elg.dispatchEvent(new Event('change'));
	tgt_elg.dispatchEvent(new Event('blur'));
	tgt_elg.dispatchEvent(new Event('focusout'));
};



// use SSN to search
input_refresh(document.querySelector("#subscriberIdNumber"), jsonObject['Employee Search']['SSN'])


var allPageTags = document.getElementsByTagName("a");
for (i = 0; i < allPageTags.length; i++) {
	if (allPageTags[i].getAttribute('title') == 'Find Employee/Dependent') {
		allPageTags[i].click();
		break;
	}
}

if (document.querySelector("#employeesCount\\.errors")){console.log('no result')}


// use name to search

input_refresh(document.querySelector("#lastName"), jsonObject['Employee Search']['Last Name'])
input_refresh(document.querySelector("#firstName"), jsonObject['Employee Search']['First Name'])


var allPageTags = document.getElementsByTagName("a");
for (i = 0; i < allPageTags.length; i++) {
	if (allPageTags[i].getAttribute('title') == 'Find Employee/Dependent') {
		allPageTags[i].click();
		break;
	}
}

if (document.querySelector("#employeesCount\\.errors")){console.log('no result')}



//=============================page3=========================================




function get_short_state(stateName) {
	const stateNameToAbbreviation = {
		'Alabama': 'AL',
		'Alaska': 'AK',
		'Arizona': 'AZ',
		'Arkansas': 'AR',
		'California': 'CA',
		'Colorado': 'CO',
		'Connecticut': 'CT',
		'Delaware': 'DE',
		'Florida': 'FL',
		'Georgia': 'GA',
		'Hawaii': 'HI',
		'Idaho': 'ID',
		'Illinois': 'IL',
		'Indiana': 'IN',
		'Iowa': 'IA',
		'Kansas': 'KS',
		'Kentucky': 'KY',
		'Louisiana': 'LA',
		'Maine': 'ME',
		'Maryland': 'MD',
		'Massachusetts': 'MA',
		'Michigan': 'MI',
		'Minnesota': 'MN',
		'Mississippi': 'MS',
		'Missouri': 'MO',
		'Montana': 'MT',
		'Nebraska': 'NE',
		'Nevada': 'NV',
		'New Hampshire': 'NH',
		'New Jersey': 'NJ',
		'New Mexico': 'NM',
		'New York': 'NY',
		'North Carolina': 'NC',
		'North Dakota': 'ND',
		'Ohio': 'OH',
		'Oklahoma': 'OK',
		'Oregon': 'OR',
		'Pennsylvania': 'PA',
		'Rhode Island': 'RI',
		'South Carolina': 'SC',
		'South Dakota': 'SD',
		'Tennessee': 'TN',
		'Texas': 'TX',
		'Utah': 'UT',
		'Vermont': 'VT',
		'Virginia': 'VA',
		'Washington': 'WA',
		'West Virginia': 'WV',
		'Wisconsin': 'WI',
		'Wyoming': 'WY'
	};
	const abbreviation = stateNameToAbbreviation[stateName];
	if (abbreviation) {
		return abbreviation;
	} else {
		return stateName;
	}
};

function get_full_state(statename) {
	const abbreviationToStateName = {
		'AL': 'Alabama',
		'AK': 'Alaska',
		'AZ': 'Arizona',
		'AR': 'Arkansas',
		'CA': 'California',
		'CO': 'Colorado',
		'CT': 'Connecticut',
		'DE': 'Delaware',
		'FL': 'Florida',
		'GA': 'Georgia',
		'HI': 'Hawaii',
		'ID': 'Idaho',
		'IL': 'Illinois',
		'IN': 'Indiana',
		'IA': 'Iowa',
		'KS': 'Kansas',
		'KY': 'Kentucky',
		'LA': 'Louisiana',
		'ME': 'Maine',
		'MD': 'Maryland',
		'MA': 'Massachusetts',
		'MI': 'Michigan',
		'MN': 'Minnesota',
		'MS': 'Mississippi',
		'MO': 'Missouri',
		'MT': 'Montana',
		'NE': 'Nebraska',
		'NV': 'Nevada',
		'NH': 'New Hampshire',
		'NJ': 'New Jersey',
		'NM': 'New Mexico',
		'NY': 'New York',
		'NC': 'North Carolina',
		'ND': 'North Dakota',
		'OH': 'Ohio',
		'OK': 'Oklahoma',
		'OR': 'Oregon',
		'PA': 'Pennsylvania',
		'RI': 'Rhode Island',
		'SC': 'South Carolina',
		'SD': 'South Dakota',
		'TN': 'Tennessee',
		'TX': 'Texas',
		'UT': 'Utah',
		'VT': 'Vermont',
		'VA': 'Virginia',
		'WA': 'Washington',
		'WV': 'West Virginia',
		'WI': 'Wisconsin',
		'WY': 'Wyoming'
	};
	const abbreviation = abbreviationToStateName[statename];
	if (abbreviation) {
		return abbreviation;
	} else {
		return statename;
	}
}


var frameObj = document.getElementsByName('Web Page')[0];

function input_refresh_bcbstx(tgt_el_name, val) {
	console.log(tgt_el_name)
	tgt_elg = frameObj.contentWindow.document.getElementsByName(tgt_el_name)[0];
	tgt_elg.dispatchEvent(new Event('focusin'));
	tgt_elg.value = val;
	tgt_elg.dispatchEvent(new Event('input'));
	tgt_elg.dispatchEvent(new Event('change'));
	tgt_elg.dispatchEvent(new Event('blur'));
	tgt_elg.dispatchEvent(new Event('focusout'));
};

function input_Date() {
	return {
		DOB: ['dobMonth', 'dobDay', 'dobYear'],
		Hire_Date: ['hrDtmm', 'hrDtdd', 'hrDtyyyy'],
		EnrollmentStartDate: ['effDtmm', 'effDtdd', 'effDtyyyy'],
		SignDate: ['signDtmm', 'signDtdd', 'signDtyyyy'],

	}
}
function getDateinfo(date_String) {
	var targetDate = new Date(date_String);
	return [(targetDate.getMonth() + 1).toString().padStart(2, '0'), targetDate.getDate().toString().padStart(2, '0'), targetDate.getFullYear().toString().padStart(4, '0')]
}

function getSSN(ssn_String) {
	var targetSSN = ssn_String.replace(/-/g, '');
	return [targetSSN.substring(0, 3), targetSSN.substring(3, 5), targetSSN.substring(5, 9)]
}

function getPhone(phone_String) {
	var targetPhone = phone_String.replace(/\D/g, '');
	return [targetPhone.substring(0, 3), targetPhone.substring(3, 6), targetPhone.substring(6, 10)]
}

const dic = {
		"First Name": "firstName",
		"Middle": "middleInitial",
		"Last Name": "lastName",
		"Gender": "gendCd",
		"Address1": "usStreetOne",
		"Address2": "usStreetTwo",
		"State": "usStCd",
		"City": "usCityName",
		"Zip": "usZipCode",
		"Primary Email": "emailAddr",
		"Married":"marStCd"
	};
	for (var keyb in dic) {
		var itemb = dic[keyb];
		if (itemb != '') {
			if (jsonObject['General Info'][keyb]&&jsonObject['General Info'][keyb] != '') {
				if (keyb == 'Gender') {
					var gender_value = jsonObject['General Info'][keyb];
					if (gender_value == 'F' || gender_value == 'Female') {
						input_refresh_bcbstx(itemb, 'F');
					} else if (gender_value == 'M' || gender_value == 'Male') {
						input_refresh_bcbstx(itemb, 'M');
					};
				} else if (keyb == 'State') {
					input_refresh_bcbstx(itemb, get_short_state(jsonObject['General Info'][keyb]));
				} else if (keyb == 'Married') {
					input_refresh_bcbstx(itemb, (jsonObject['General Info'][keyb][0]));
				}else {
					input_refresh_bcbstx(itemb, jsonObject['General Info'][keyb]);
				}
			}
		}
	}



	var inDate = input_Date();


	var infoMapping = {
		EnrollmentStartDate: 'Enrollment Start Date',
		SignDate: 'Changed On',
		DOB: 'DOB',
		Hire_Date: 'Hire_Date',

	};

	for (var keym in inDate) {
		var property = infoMapping[keym] || keym; // Fallback to keym if specific mapping is not found
		var dateString = jsonObject['General Info'][property]; // Access the mapped property
		inDate[keym].forEach(function(dateField, index) {
			input_refresh_bcbstx(dateField, getDateinfo(dateString)[index]);
		});
	}
	
	var ssn = jsonObject['General Info']['SSN'];
	var ssn_subName = ["ssnFirst", "ssnMiddle", "ssnLast"];
	if (ssn != '') {
		for (var n = 0; n < ssn_subName.length; n++) {
			input_refresh_bcbstx(ssn_subName[n], getSSN(ssn)[n]);
		}
	}
	

	var homephone = jsonObject['General Info']['HOMEPHONE'];
	var homephone_Name = ["homePhone123", "homePhone456", "homePhone7890"];
	if (homephone != '') {
		for (var m = 0; m < homephone_Name.length; m++) {
			input_refresh_bcbstx(homephone_Name[m], getPhone(homephone)[m]);
		}
	}
	var busphone = jsonObject['General Info']['WORKPHONE'];
	var busphone_Name = ["busPhone123", "busPhone456", "busPhone7890"];
	if (busphone != '') {
		for (var m = 0; m < homephone_Name.length; m++) {
			input_refresh_bcbstx(busphone_Name[m], getPhone(busphone)[m]);
		}
	}
	

//=============================page4=========================================

document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByName('char_CMSESC')[0].value = 'A'





//=============================page5=========================================



function input_refresh(tgt_elg, val) {
	tgt_elg.dispatchEvent(new Event('focusin'));
	tgt_elg.value = val;
	tgt_elg.dispatchEvent(new Event('input'));
	tgt_elg.dispatchEvent(new Event('change'));
	tgt_elg.dispatchEvent(new Event('blur'));
	tgt_elg.dispatchEvent(new Event('focusout'));
};


var pt_el = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByName('hlthProd')[0];
input_refresh(pt_el, jsonObject['Coverage Info']['Plan Name'])


//--------------------------will refresh, need invoke below in next PAD element

var p_el = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByName('hnewba')[0];

selectOptionByText(p_el, jsonObject['Coverage Info']['Product']);


function selectOptionByText(selectElement, searchText) {
    for (const option of selectElement.options) {
        if (option.textContent.trim().includes(searchText)) {
            selectElement.value = option.value;
            selectElement.dispatchEvent(new Event('change')); // Trigger the onchange event
            break;
        }
    }
}

//--------------------------will refresh, need invoke below in next PAD element

var cov_lv = jsonObject['Coverage Info']['Coverage Level'];
if (cov_lv == 'N') {
	
	var el = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByName('hsmf')[1]
	.dispatchEvent(new Event('focusin'));
	tgt_elg.checked = true;
	tgt_elg.dispatchEvent(new Event('input'));
	tgt_elg.dispatchEvent(new Event('change'));
	tgt_elg.dispatchEvent(new Event('blur'));
	tgt_elg.dispatchEvent(new Event('focusout'));
	
} else if (cov_lv == 'Y') {
		
	var el = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByName('hsmf')[0]
	.dispatchEvent(new Event('focusin'));
	tgt_elg.checked = true;
	tgt_elg.dispatchEvent(new Event('input'));
	tgt_elg.dispatchEvent(new Event('change'));
	tgt_elg.dispatchEvent(new Event('blur'));
	tgt_elg.dispatchEvent(new Event('focusout'));

	
	
}


//=============================page5=========================================



function selectOptionByText(tgt_elg, text) {
	el = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByName(tgt_elg)[0];
    for (var i = 0; i < el.options.length; i++) {
        if (el.options[i].text.trim() === text) {
            el.value = el.options[i].value;
            break;
        }
    }
}

function input_refresh_bcbstx(tgt_el_name, val) {
	console.log(tgt_el_name)
	tgt_elg = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByName(tgt_el_name)[0];
	tgt_elg.dispatchEvent(new Event('focusin'));
	tgt_elg.value = val;
	tgt_elg.dispatchEvent(new Event('input'));
	tgt_elg.dispatchEvent(new Event('change'));
	tgt_elg.dispatchEvent(new Event('blur'));
	tgt_elg.dispatchEvent(new Event('focusout'));
};


child_ct = jsonObject['Depebdent Summary']['First Name'].split("|").length;

// if (child_ct>5){
	
		
	// for (var m = 0; m < child_ct-5; m++) {

		

		// }
	
// }
// console.log(child_ct)

for (var m = 0; m < child_ct; m++) {
	
	input_dependent(m+1, true, m) 

	}



function add_more(){
var allPageTags = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByTagName("a");
for (i = 0; i < allPageTags.length; i++) {
	if (allPageTags[i].textContent == 'Add another dependent') {
		allPageTags[i].click();
		break;
	}
}}

function getDateinfo(date_String) {
	var targetDate = new Date(date_String);
	return [(targetDate.getMonth() + 1).toString().padStart(2, '0'), targetDate.getDate().toString().padStart(2, '0'), targetDate.getFullYear().toString().padStart(4, '0')]
}

function getSSN(ssn_String) {
	var targetSSN = ssn_String.replace(/-/g, '');
	return [targetSSN.substring(0, 3), targetSSN.substring(3, 5), targetSSN.substring(5, 9)]
}

function dep_dob_ssn_info(i) {
	return {
		DOB: ['dobmm_dep' + i, 'dobdd_dep' + i, 'dobyyyy_dep' + i],
		SSN: ['ssn13_dep' + i, 'ssn45_dep' + i, 'ssn69_dep' + i]
	}
}


function input_dependent(i, bln_needindex, index) {
	var idx = index;
	const dic = {
		"First Name": "fname_dep" + i,
		"Last Name": "lname_dep" + i,
		"Middle": "mi_dep" + i,
		"Relationship": "relCd_dep" + i,
		"Gender": "gender_dep" + i
	};
	for (var ky in dic) {
		var items = dic[ky];
		if (bln_needindex == false) {
			value_jsonObject = jsonObject['Depebdent Summary'][ky];
		} else {
			value_jsonObject = jsonObject['Depebdent Summary'][ky].split('|')[idx];
		};
		
		
			if (ky == 'Gender') {
				var gender_value = value_jsonObject;
				if (gender_value == 'F' || gender_value == 'Female') {
					input_refresh_bcbstx(items, 'F');
				} else if (gender_value == 'M' || gender_value == 'Male') {
					input_refresh_bcbstx(items, 'M');
				}
			} else if (ky == 'Relationship'){
				var Relationship_value= value_jsonObject;
				
				selectOptionByText(items, value_jsonObject)
				
			}else {
				input_refresh_bcbstx(items, value_jsonObject);
			}
		
	}


	for (var kyx in dep_dob_ssn_info(idx)) {
		
		if (bln_needindex == false) {
			var stringInfo = jsonObject['Depebdent Summary'][kyx];
		} else {
			var stringInfo = jsonObject['Depebdent Summary'][kyx].split('|')[idx];
		};
		
		for (var j = 0; j < 3; j++) {
				var ssnel = dep_dob_ssn_info(idx+1)
			if (kyx == 'DOB') {
				input_refresh_bcbstx(ssnel[kyx][j], getDateinfo(stringInfo)[j]);
			} else {
				input_refresh_bcbstx(ssnel[kyx][j], getSSN(stringInfo)[j]);
			}
		}
	}

}



//===========================add dept section



var jsonObject = {
  "Search Criteria": {
    "AccountID": "160157"
  },
  "Employee Search": {
    "Find an Employee/Dependent": "Employee",
    "SSN": "123456780",
    "Last Name": "FUENTES",
    "First Name": "FUENTES",
    "DOB": "08/29/1987"
  },
  "General Info": {
    "Enrollment Start Date": "04/01/2024",
    "Type of Enrollment:": "Initial",
    "Event Reason": "NewHire",
    "HIPPA Certification:": "No",
    "Other Insurance:": "Unknown ",
    "Changed On": "04/23/2024",
    "First Name": "AMELIA",
    "Last Name": "FUENTES",
    "Gender": "Female",
    "SSN": "123456780",
    "DOB": "08/29/1987",
    "Married": "Unknown",
    "Hire_Date": "05/18/2023",
    "Status:": "Active",
    "Age When Enrollment Start (Enrollment Start Date - DOB )": "Unknown",
    "Native Language:": "English",
    "Preferred Written Language:": "English",
    "Preferred Spoken Language:": "English",
    "Race/Ethnicity": "Unknown",
    "Country": "United States",
    "Address1": "123 AVE APT 2A",
    "City": "Chicago",
    "State": "IL",
    "Zip": "606382860",
    "Home Phone": "7081234567",
    "Primary Email": "123@321.net"
  },
  "Employee Info": {
    "CMS Employee Status Code:": "A - Active",
    "*Actively Employed:": "Yes",
    "Sub CDHP Elections:": "*Pls. manually handle, If the group have the field in BCBS - out of automationin phase 1"
  },
  "Coverage Info": {
    "Plan Name - Medical": "BLUE OPTIONS",
    "Product - Medical": "0007 G506OPT",
    "Coverage Level - Medical": "Y",
    "PCP (Medical)": "No",
    "PCP (OBGYN)": "No",
    "*Dental Clinic Number:": "*Pls. manually handle, If the group have the field in BCBS - out of automationin phase 1"
  },
  "Depebdent Summary": {
    "Last Name": "Dook|Fook",
    "First Name": "AA|BB",
    "Middle": " | ",
    "Relationship": "Dependent Child|Dependent Child",
    "Gender": "Female|Male",
    "DOB": "10/20/2011|08/06/2007",
    "SSN": "123456781|123456782",
    "Native Language:": "English|English",
    "Preferred Written Language:": "English|English",
    "Preferred Spoken Language:": "English|English",
    "Ethnicity (select all that apply):": "Unknown|Unknown",
    "Race (select all that apply):": "Unknown|Unknown",
    "Medicare Eligible": "No|No",
    "Different address information than the employee?": "No|No"
  }
}


function add_more(){
var allPageTags = document.getElementsByName('Web Page')[0].contentWindow.document.getElementsByTagName("a");
for (i = 0; i < allPageTags.length; i++) {
	if (allPageTags[i].textContent == 'Add another dependent') {
		allPageTags[i].click();
		break;
	}
}}

child_ct = jsonObject['Depebdent Summary']['First Name'].split("|").length;

if (child_ct>5){
	
		
	for (var m = 0; m < child_ct-5; m++) {

		add_more()

		}
	
}
console.log(child_ct)
