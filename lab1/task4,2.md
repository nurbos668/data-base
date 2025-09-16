#### **1. Determine the Primary Key**

The primary key must uniquely identify each record (each row). According to the business rules:
* A student can be enrolled in multiple course sections.
* Each course section is taught by one instructor, at one time, in one room.

A course section is uniquely identified by the combination of `CourseID`, `TimeSlot`, and `Room`. However, a record in this table represents a student's enrollment in a course section. Therefore, to uniquely identify a record, you need both the **student** and the **course section**.

The primary key is: **`{StudentID, CourseID, TimeSlot, Room}`**.

#### **2. List all Functional Dependencies (FDs)**

Here are the functional dependencies based on the primary key and business rules:

* **Full Dependencies (on the primary key):**
    * `{StudentID, CourseID, TimeSlot, Room}` -> `StudentMajor`, `CourseName`, `InstructorID`, `InstructorName`, `Building`
* **Partial Dependencies (on a subset of the primary key):**
    * `{StudentID}` -> `StudentMajor` (A student has exactly one major)
    * `{CourseID}` -> `CourseName` (Each course has a fixed name)
    * `{CourseID, TimeSlot, Room}` -> `InstructorID`, `InstructorName` (Each course section is taught by one instructor)
    * `{Room, TimeSlot}` -> `Building` (A time slot in a room determines the building)
* **Transitive Dependencies:**
    * `{CourseID, TimeSlot, Room}` -> `{InstructorID}` -> `InstructorName` (The instructor's name is determined by the instructor ID, not the course section)
    * `{CourseID, TimeSlot, Room}` -> `{Room, TimeSlot}` -> `Building` (The building is determined by the room and time slot, not the course ID)

#### **3. Check if the table is in BCNF**

A table is in **BCNF** if and only if every determinant is a candidate key.

* A **determinant** is an attribute (or a set of attributes) on the left side of a functional dependency.
* A **candidate key** is an attribute (or a set of attributes) that uniquely identifies a row.

The primary key `{StudentID, CourseID, TimeSlot, Room}` is a candidate key, but there are other determinants that are **not** candidate keys, such as:
* `{StudentID}`
* `{CourseID}`
* `{CourseID, TimeSlot, Room}`
* `{Room, TimeSlot}`
* `{InstructorID}`

Since we have determinants that are not candidate keys, the table is **not in BCNF**.

#### **4. Decompose to BCNF**

To reach BCNF, we must decompose the table to remove all dependencies where the determinant is not a candidate key. We do this by creating new tables for each dependency.

**Initial Table:** `CourseSchedule(StudentID, StudentMajor, CourseID, CourseName, InstructorID, InstructorName, TimeSlot, Room, Building)`

**Decomposition Step 1 (Remove partial dependencies on StudentID):**
* **New Table:** `Students(StudentID, StudentMajor)`
* **Remaining Table:** `CourseSchedule(StudentID, CourseID, CourseName, InstructorID, InstructorName, TimeSlot, Room, Building)`
* **The original `StudentID` in `CourseSchedule` becomes a foreign key.**

**Decomposition Step 2 (Remove partial dependencies on CourseID):**
* **New Table:** `Courses(CourseID, CourseName)`
* **Remaining Table:** `CourseSchedule(StudentID, CourseID, InstructorID, InstructorName, TimeSlot, Room, Building)`

**Decomposition Step 3 (Remove dependencies on CourseID, TimeSlot, Room and Room, TimeSlot):**
* **New Table:** `CourseSections(CourseID, TimeSlot, Room, InstructorID, Building)`
* **Remaining Table:** `CourseSchedule(StudentID, CourseID, TimeSlot, Room)`

**Decomposition Step 4 (Remove transitive dependency on InstructorID):**
* **New Table:** `Instructors(InstructorID, InstructorName)`
* **Remaining Table:** `CourseSections(CourseID, TimeSlot, Room, InstructorID, Building)`

**Final BCNF Decomposition:**
1.  **Students**
    * **Schema:** `(StudentID, StudentMajor)`
    * **PK:** `StudentID`
2.  **Courses**
    * **Schema:** `(CourseID, CourseName)`
    * **PK:** `CourseID`
3.  **Instructors**
    * **Schema:** `(InstructorID, InstructorName)`
    * **PK:** `InstructorID`
4.  **Rooms**
    * **Schema:** `(Room, TimeSlot, Building)`
    * **PK:** `{Room, TimeSlot}`
5.  **CourseSections**
    * **Schema:** `(CourseID, TimeSlot, Room, InstructorID)`
    * **PK:** `{CourseID, TimeSlot, Room}`
6.  **Enrollments**
    * **Schema:** `(StudentID, CourseID, TimeSlot, Room)`
    * **PK:** `{StudentID, CourseID, TimeSlot, Room}`
    * All attributes are foreign keys referencing other tables.

#### **5. Explain any potential loss of information**
In a lossless decomposition, you can join the new tables back together and recreate the original table without losing any information. This decomposition is lossless.
