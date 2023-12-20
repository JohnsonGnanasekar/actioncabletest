# README

This is sample AI based chat app created for assignment.

Local Performance Analysis:

1. Seeding process :
	Before optimisation: 175.08924500000285 seconds
	After optimisation: 17.734820999998192 seconds
2. Profile index page: 
	Before optimisation:  20.0ms
	After optimisation: 11.3ms
3. Profile index page with gender filter:
        Before optimisation:  17.6ms 
	After optimisation: 5.8ms
4. Profile index page with category filter:
	Before optimisation: 18.1ms
	After optimisation: 7.5ms
4. Profile index page with gender and category filter:
	Before optimisation: 20.8ms
	After optimisation: 17.8ms 
4. Chat index db execution:
	Before optimisation: 1.7 ms
	After optimisation: 1.6ms 

Used Benchmark & middleware default execution time logger.

Optimazation steps taken:
1. Added index to Profiles table for gender & category columns since its used in UI filter action.
2. Added batch level of seeding process for profile load instead active record create logic.
3. Added index to Messages table for role column & already user_id index added through user table reference instruction.
4. Added bullet gem to track any N+1 query execution & tracking long query execution in this app.
5. Pagination was already added to Profile index page.
