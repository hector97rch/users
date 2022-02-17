# Instructions for runing the project

* Clone the projec on the server.

## Users project.
    * create an image 
     in the terminal enter the next command **docker build -t users:0.1.0 .**
    * run the project 
    in the terminal enter the next command **docker run --network host users:0.1.0**
    * stop the project
    1. in a new terminal enter **docker ps** and copy the id of the users image.
    2. enter **docker stop id**


