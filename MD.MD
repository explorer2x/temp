---
markmap:
  activeNode: {}
  initialExpandLevel: 
---

# Workflow for Group Analysis

## 1. **New Group**
### Criteria:
- Group names that are **newly subscribed** today compared to yesterday.
- Group names that are **not present** in the `Carrier Related Info Tab / Column B` of the Worklog.
- Both conditions must be satisfied.


### Steps:
1. **Compare Subscriptions**:
   - Extract group names subscribed today.
   - Compare with group names subscribed yesterday.
   - Identify new group names.

2. **Compare with Worklog**:
   - Check if the new group names are absent in `Carrier Related Info Tab / Column B`.

3. **Check EN Company Plan Raw**:
   - For each new group, retrieve the associated plan names.

4. **Output**:
   - `{
  "New Group1": ["plan_name1", "plan_name2"],
  "New Group2": ["plan_name3", "plan_name4"],
  "New Group3": ["plan_name5"]
}`.

### Output Format:
```json
{
  "Group Name in EN": "New Group1",
  "Plan Name in EN":  ["plan_name1", "plan_name2"],
  "Group Name in BCBS IL": "New Group1",
  "Account # in BCBS IL": ""
}
```
---

## 2. **Renewed Group**
### Criteria:
- Group names that satisfy the **EN Company Plan Report** filters.

### Steps:
1. **Filter EN Company Plan Report**:
   - Identify group names that meet the report criteria.

2. **Retrieve Worklog Data**:
   - For each group, find the corresponding `Group Name in BCBS IL` and `Account # in BCBS IL` from the Worklog.

3. **Output**:
   - Format the results as `{Group Name in EN, Plan Name in EN, Group Name in BCBS IL, Account # in BCBS IL}`.

### Output Format:
```json
{
  "Group Name in EN": "Group_Name from EN Company Plan Report",
  "Plan Name in EN": ["Plan_Name1 from EN Company Plan Report","Plan_Name2 from EN Company Plan Report"],
  "Group Name in BCBS IL": "Group_Name locate in Worklog per Group Name in EN",
  "Account # in BCBS IL": "Account_# locate in Worklog per Group Name in EN"
}
```

---

## 3. **Email Group**
### Criteria:
- Group names where:
  - `Column B` in `Carrier Related Info Tab` is **"N/A"**.
  - `Column C` in `Carrier Related Info Tab` is **not "N/A"**.

### Steps:
1. **Check Worklog Columns**:
   - Identify group names where `Column B` is "N/A" and `Column C` is not "N/A".

2. **Retrieve BCBS IL Data**:
   - For each group, extract `Group Name in BCBS IL` and `Account # in BCBS IL`.

3. **Output**:
   - Format the results as `{Group Name in EN: "N/A", Plan Name in EN: "N/A", Group Name in BCBS IL, Account # in BCBS IL}`.

### Output Format:
```json
{
  "Group Name in EN": "N/A",
  "Plan Name in EN": ["Plan Name1 from worklog","Plan Name2 from worklog"],
  "Group Name in BCBS IL": "Group_Name_in_BCBS_IL",
  "Account # in BCBS IL": "Account_#_in_BCBS_IL"
}
```

---

# **Extract Product Information from BCBS IL**

## Steps:
1. **For New Group**:
   - `Group Name in BCBS IL` = `Group Name in EN`.
   - `Account # in BCBS IL` = "N/A".
   - USE `Group Name in EN` TO LOCATE GROUP IN BCBSIL

2. **For Renewed Group**:
   - `Group Name in BCBS IL` = Lookup in Worklog.
   - `Account # in BCBS IL` = Lookup in Worklog.
   - USE `Account # in BCBS IL` TO LOCATE GROUP IN BCBSIL

3. **For Email Group**:
   - `Group Name in BCBS IL` = Directly from BCBS IL.
   - `Account # in BCBS IL` = Directly from BCBS IL.
   -  USE `Account # in BCBS IL` TO LOCATE GROUP IN BCBSIL

---

## Summary of Outputs
### New Group:
```json
[{
  "Group Name in EN": "New Group1",
  "Plan Name in EN": ["plan_name1", "plan_name2"],
  "Product Info":  [
      {
        "Product": "BLUE PRECISION",
        "optionText": "0001 P999xxN"
      },
      {
        "Product": "PPO",
        "optionText": "0002 P888xxN"
      }
    ],
  "Group Name in BCBS IL": "New Group1",
  "Account # in BCBS IL": ""
},{
  "Group Name in EN": "New Group2",
  "Plan Name in EN": ["plan_name1", "plan_name2"],
  "Product Info":  [
      {
        "Product": "BLUE PRECISION",
        "optionText": "0001 P999xxN"
      },
      {
        "Product": "PPO",
        "optionText": "0002 P888xxN"
      }
    ],
  "Group Name in BCBS IL": "New Group2",
  "Account # in BCBS IL": ""
}]
```

### Renewed Group:
```json
[{
  "Group Name in EN": "Group_Name1 from EN Company Plan Report",
  "Plan Name in EN":  ["Plan_Name1 from EN Company Plan Report","Plan_Name2 from EN Company Plan Report"],
  "Product Info":  [
      {
        "Product": "BLUE PRECISION",
        "optionText": "0001 P999xxN"
      },
      {
        "Product": "PPO",
        "optionText": "0002 P888xxN"
      }
    ],
  "Group Name in BCBS IL": "Group_Name1 locate in Worklog per Group Name in EN",
  "Account # in BCBS IL": "Account_#1 locate in Worklog per Group Name in EN"
},{
  "Group Name in EN": "Group_Name2 from EN Company Plan Report",
  "Plan Name in EN":  ["Plan_Name1 from EN Company Plan Report","Plan_Name2 from EN Company Plan Report"],
  "Product Info":  [
      {
        "Product": "BLUE PRECISION",
        "optionText": "0001 P999xxN"
      },
      {
        "Product": "PPO",
        "optionText": "0002 P888xxN"
      }
    ],
  "Group Name in BCBS IL": "Group_Name2 locate in Worklog per Group Name in EN",
  "Account # in BCBS IL": "Account_#2 locate in Worklog per Group Name in EN"
}]
```

### Email Group:
```json
[{
  "Group Name in EN": "N/A",
  "Plan Name in EN": ["Plan Name1 from worklog","Plan Name2 from worklog"],
  "Product Info":  [
      {
        "Product": "BLUE PRECISION",
        "optionText": "0001 P999xxN"
      },
      {
        "Product": "PPO",
        "optionText": "0002 P888xxN"
      }
    ],
  "Group Name in BCBS IL": "Group_Name1_in_BCBS_IL",
  "Account # in BCBS IL": "Account_#1_in_BCBS_IL"
},{
  "Group Name in EN": "N/A",
  "Plan Name in EN": ["Plan Name1 from worklog","Plan Name2 from worklog"],
  "Product Info":  [
      {
        "Product": "BLUE PRECISION",
        "optionText": "0001 P999xxN"
      },
      {
        "Product": "PPO",
        "optionText": "0002 P888xxN"
      }
    ],
  "Group Name in BCBS IL": "Group_Name2_in_BCBS_IL",
  "Account # in BCBS IL": "Account_#2_in_BCBS_IL"
}]
```
