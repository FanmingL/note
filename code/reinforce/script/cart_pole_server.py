#! /usr/bin/python2
# coding=utf-8
#================================================================
#   Copyright (C) 2018 * Ltd. All rights reserved.
#   
#   File name   : cart_pole_server.py
#   Author      : FanmingL
#   Created date: 2018-12-14 22:11:09
#   Description : 
#
#================================================================

import rospy
import actionlib
import gym
from geometry_msgs.msg import Pose
from std_msgs.msg import Int32, Header
import time
import numpy as np
from reinforce.msg import CartControlResult, CartControlGoal, CartControlAction

class CartPoleServer:

    def __init__(self, name_):
        rospy.init_node(name=name_)
        self.env = gym.make('CartPole-v0')
        # self.server = actionlib.SimpleActionServer('cart_control', CartControlAction, self.call_back, auto_start=False)
        self.sub = rospy.Subscriber('cart_control', CartControlGoal, self.call_back, queue_size=1)
        self.pub = rospy.Publisher('cart_status', CartControlResult, queue_size=1)
        self.data = []
        self.done = False
        self.reward = 0
        self.data = self.env.reset()
        # self.server.start()
        self.message_to_send = CartControlResult()

    def run(self):
        rospy.spin()

    def call_back(self, data):
        if not data.control == 2:
            self.data, self.reward, self.done, _ = self.env.step(data.control)
        if self.done:
            self.env.reset()
        self.message_to_send.cart_position, self.message_to_send.cart_velocity, \
            self.message_to_send.pole_angle, self.message_to_send.pole_velocity = self.data
        self.message_to_send.done = self.done
        self.message_to_send.reward = self.reward
        self.message_to_send.header.frame_id = '1'
        self.message_to_send.header.stamp = rospy.Time.now()
        self.message_to_send.header.seq += 1
        #self.server.set_succeeded(result=self.message_to_send)
        self.pub.publish(self.message_to_send)
        # print (rospy.Time.now()).to_sec() * 1000
        # self.env.render()


if __name__ == '__main__':
    instance = CartPoleServer('cart')
    instance.run()
