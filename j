// Define the function to check for duplicate plan types
function checkForDuplicatePlanTypes(employeeData) {
    const employeeIds = Object.keys(employeeData); // Get all employee IDs
    const results = {};

    employeeIds.forEach(employeeId => {
        const enrolledPlans = employeeData[employeeId].EEINFO[0].EE_BENEFIT["Enrolled Plans"];
        const planTypes = enrolledPlans.map(plan => plan["Plan Type"]);
        const hasDuplicates = new Set(planTypes).size !== planTypes.length; // Check for duplicates

        results[employeeId] = hasDuplicates ? "Duplicate plan types found" : "No duplicates";
    });

    return results;
}

// Sample JSON data (make sure to replace this with the actual JSON data)
const employeeData = {
  "135388": {
    "EEINFO": [
      {
        "EE_BENEFIT": {
          "Enrolled Plans": [
            // Plan details...
          ]
        }
      }
    ]
  },
  // Add other employees...
};

// Check for duplicates
console.log(checkForDuplicatePlanTypes(employeeData));
