/*================================================================
*   Copyright (C) 2018 * Ltd. All rights reserved.
*   
*   File name   : reinforce_node.cpp
*   Author      : FanmingL
*   Created date: 2018-12-14 23:12:39
*   Description : 
*
*===============================================================*/


#include "reinforce_node.h"

Reinforce::Reinforce() {
    sub = _nh.subscribe<reinforce::CartControlResult>("cart_status", 1, boost::bind(&Reinforce::CB, this, _1));
    pub = _nh.advertise<reinforce::CartControlGoal>("cart_control", 1);
}

void Reinforce::Run() {
    usleep(1000000);
    ros::Rate rate(200);
    goal.control = 2;

    pub.publish(goal);
    uint32_t old = goal.header.seq;
    while (ros::ok()){
        ros::spinOnce();
        if (goal.header.seq != old)
        {
            pub.publish(goal);
            old = goal.header.seq;
        }
        rate.sleep();
    }
}

void Reinforce::CB(const reinforce::CartControlResultConstPtr &res) {
    goal.header.seq++;
    goal.header.stamp = ros::Time::now();
    goal.control = std::rand() % 2 ;
}


int main(int argc, char** argv){
    ros::init(argc, argv, "dqn");
    Reinforce ins;
    ins.Run();
    return 0;
}