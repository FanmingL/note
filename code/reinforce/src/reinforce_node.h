/*================================================================
*   Copyright (C) 2018 * Ltd. All rights reserved.
*   
*   File name   : reinforce_node.h
*   Author      : FanmingL
*   Created date: 2018-12-14 23:13:39
*   Description : 
*
*===============================================================*/


#ifndef _REINFORCE_NODE_H
#define _REINFORCE_NODE_H

#include "ros/ros.h"
#include "actionlib/client/simple_action_client.h"
#include "reinforce/CartControlAction.h"
#include "reinforce/CartControlResult.h"
#include "reinforce/CartControlGoal.h"
#include <iostream>
#include <chrono>

class Reinforce{
public:
    Reinforce();

    ~Reinforce() = default;

    void Run();

    //void CB(const actionlib::SimpleClientGoalState &msg, const reinforce::CartControlResultConstPtr &res);
    void CB(const reinforce::CartControlResultConstPtr &res);
private:
    ros::NodeHandle _nh;

    //actionlib::SimpleActionClient<reinforce::CartControlAction> ac;

    reinforce::CartControlGoal goal;

    ros::Subscriber sub;

    ros::Publisher pub;

};

#endif //REINFORCE_Nin