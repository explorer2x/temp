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