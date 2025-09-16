1.  **Identify functional dependencies (FDs).**
    The main functional dependencies in the `StudentProject` table are:
    * `StudentID` -> `StudentName`, `StudentMajor`
    * `ProjectID` -> `ProjectTitle`, `ProjectType`
    * `SupervisorID` -> `SupervisorName`, `SupervisorDept`
    * `StudentID`, `ProjectID` -> `Role`, `HoursWorked`, `StartDate`, `EndDate`

2.  **Identify problems and anomalies.**
    * **Redundancy:** Information about students, projects, and supervisors is repeated across multiple rows. For example, a student's name and major are stored for every project they work on.
    * **Update Anomaly:** If a student changes their major, every record for that student must be updated. Missing even one update would lead to inconsistent data.
    * **Insert Anomaly:** It's impossible to add a new supervisor to the database unless they are already assigned to a project.
    * **Delete Anomaly:** Deleting the last project a student is working on will also delete all information about that student (e.g., their major).

3.  **Apply 1NF.**
    The table is already in **1NF** because all attributes are atomic and there are no repeating groups.

4.  **Apply 2NF.**
    The primary key is `{StudentID, ProjectID}`. The following are partial dependencies:
    * `StudentID` -> `StudentName`, `StudentMajor`
    * `ProjectID` -> `ProjectTitle`, `ProjectType`, `SupervisorID`

    To fix this, we decompose the table into **2NF**:
    * **Students** (`StudentID`, `StudentName`, `StudentMajor`)
    * **Projects** (`ProjectID`, `ProjectTitle`, `ProjectType`, `SupervisorID`)
    * **StudentProject** (`StudentID`, `ProjectID`, `Role`, `HoursWorked`, `StartDate`, `EndDate`)

5.  **Apply 3NF.**
    There is a transitive dependency in the `Projects` table: `ProjectID` -> `SupervisorID` and `SupervisorID` -> `SupervisorName`, `SupervisorDept`.

    To achieve **3NF**, we extract the supervisor information into a new table.

    **Final 3NF Decomposition:**
    * **Students**
        * Schema: `StudentID`, `StudentName`, `StudentMajor`
        * Primary Key: `StudentID`
    * **Supervisors**
        * Schema: `SupervisorID`, `SupervisorName`, `SupervisorDept`
        * Primary Key: `SupervisorID`
    * **Projects**
        * Schema: `ProjectID`, `ProjectTitle`, `ProjectType`, `SupervisorID` (FK)
        * Primary Key: `ProjectID`
    * **StudentProject**
        * Schema: `StudentID` (FK), `ProjectID` (FK), `Role`, `HoursWorked`, `StartDate`, `EndDate`
        * Primary Key: `{StudentID, ProjectID}`
