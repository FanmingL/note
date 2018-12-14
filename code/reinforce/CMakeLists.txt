cmake_minimum_required(VERSION 2.8.3)
project(reinforce)
set(CMAKE_CXX_STANDARD 14)
find_package(catkin REQUIRED COMPONENTS
  actionlib
  actionlib_msgs
  geometry_msgs
  roscpp
  rospy
  std_msgs
  tf
)


add_action_files(
 FILES
 CartControl.action
)

generate_messages(
 DEPENDENCIES
 actionlib_msgs
 geometry_msgs
 std_msgs
)

catkin_package(
)
include_directories(
  ${catkin_INCLUDE_DIRS}
        /home/erdou/workspace/devel/include
)
add_executable(${PROJECT_NAME}_node src/reinforce_node.cpp)
add_dependencies(${PROJECT_NAME}_node ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
target_link_libraries(${PROJECT_NAME}_node
  ${catkin_LIBRARIES}
)

