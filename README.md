# Data Handling - API

##  user profile management
Develop a User Profile Management with advanced features to manage user data.
The app will have multiple functionalities like creating, fetching, updating, and deleting user profiles.
The project will also include caching, error handling, and responsive UI.


# Requirements 
    - Implement Dio requests for API.
    -  parsing and modeling JSON data.
    - Error handling using try-catch.
    - Perform CRUD operations: Create, Read, Update, and Delete user profiles.
    - caching data with shared preferences.
    - Build a responsive UI for listing, adding, and editing profiles.
    - Pass data between screens and manage states effectively.

==================================================
#### Draft
    - fetch data from `https://jsonplaceholder.typicode.com/users`
    - add `dio` `shared_preferences` packages.
    - define `user-model` to map data.
    - add `shared_preferences` for local caching. 
    - `on-restart` check caching data:
      - case: have cached `parse` data to list and display directly.
      - case: no cached use `api` to load data and then cached them.