1.  **List at least 6 different superkeys.**
    * A superkey is any set of attributes that uniquely identifies a row. Examples:
        * `{EmpID}`
        * `{SSN}`
        * `{Email}`
        * `{EmpID, Name}`
        * `{SSN, Phone}`
        * `{EmpID, SSN, Email, Phone, Name, Department, Salary}`

2.  **Identify all candidate keys.**
    * A candidate key is a minimal superkey. The candidate keys are:
        * `{EmpID}`
        * `{SSN}`
        * `{Email}`

3.  **Which candidate key would you choose as the primary key and why?**
    * I would choose **`{EmpID}`** as the primary key. It's an ideal choice because it's a simple, stable, and unique identifier assigned by the company. Using `SSN` is discouraged due to its sensitive nature, and an `Email` address can sometimes change.

4.  **Can two employees have the same phone number? Justify your answer based on the data shown.**
    * **Yes, they can.** The sample data shows that both John and Mary have the same phone number (`555-0101`), which proves that the `Phone` attribute is not unique.
