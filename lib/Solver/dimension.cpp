//
//  dimension.cpp
//  TestLocal
//
//  Created by 李博 on 15/2/5.
//  Copyright (c) 2015年 Libo. All rights reserved.
//
#ifndef __TestLocal
#define __TestLocal

#include "klee/dimension.h"
#include "klee/tinyxml.h"
#include <iostream>
#include <vector>
#include <algorithm>
#include <map>
#include <math.h>

namespace MyDim {
    
    dimensionNode dimension::getDimension(std::string dimName)//使用该方法获取量纲节点
    {
        if (this->resultTable.find(dimName) != this->resultTable.end())
        {
            //Console.WriteLine("该记录从hash表中取得");
            return (dimensionNode)this->resultTable[dimName];
        }
        else
        {
            std::cout<<"量纲未查找到！"<<std::endl;
            dimensionNode result;
            return result;
        }
    }
    bool dimension::getBaseDimension()//读取xml基础量纲
    {
        TiXmlDocument doc("dimension.xml");
        bool loadOkay = doc.LoadFile();
        if ( !loadOkay )
        {
            printf( "Could not load test file 'dimension.xml'. Error='%s'. Exiting.\n", doc.ErrorDesc() );
            exit( 1 );
        }
        
        TiXmlElement *RootElement = doc.RootElement();
        std::cout << RootElement->Value() << std::endl;
        
        TiXmlElement *BaseD = RootElement->FirstChildElement();
        int num = 0;
        
        //获取Base数量
        TiXmlElement* node = BaseD->FirstChildElement();
        while (node != NULL) {
            num++;
            node = node->NextSiblingElement();
        }
        
        node = BaseD->FirstChildElement();
        for (int i = 0; i < num; i++)//遍历基础量纲节点
        {
            std::string name = node->FirstAttribute()->Value();
            //所查找内容为基础量纲
            
            dimensionNode dimNode(name);
            std::cout<<"初始化基础量纲:"<<name<<std::endl;
            
            for (int j = 0; j < num; j++)//生成量纲节点
            {
                if (j == i)
                {
                    dimNode.addDimension(1);
                }
                else
                {
                    dimNode.addDimension(0);
                }
                dimNode.addCoefficientAndOffset(1, 0);
            }
            this->resultTable[name] = dimNode;
            
            //所查找内容可能为基础子量纲
            TiXmlElement *trans = node->FirstChildElement();
            float coefficient = 0.0;
            float offset = 0.0;
            while (trans != NULL) {
                name = trans->FirstAttribute()->Value();
                dimensionNode dimNode(name);
                std::cout<<"初始化基础子量纲:"<<name<<std::endl;
                
                for (int l = 0; l < num; l++)
                {
                    if (l == i)
                    {
                        trans->QueryFloatAttribute("coefficient", &coefficient);
                        trans->QueryFloatAttribute("offset", &offset);
                        dimNode.addCoefficientAndOffset(coefficient, offset);
                        dimNode.addDimension(1);
                    }
                    else
                    {
                        dimNode.addDimension(0);
                    }
                }
                this->resultTable[name] = dimNode;
                trans = trans->NextSiblingElement();
            }
            node = node->NextSiblingElement();
        }
        return true;
    }
    
    

    void GauseSolver::AddConstraint(std::vector<ope> deter, dimensionNode constant, std::string info, bool ambiguous)
    {
        std::vector<opei> arr;
        // WTuple<int, double>[] arr = new WTuple<int, double>[constraint.Count];
        int i = 0;
        for (i=0; i<deter.size(); i++)
        {
            std::string s = deter[i].first;
            if(s == "")
                continue;
            if (para_pos.find(s) == para_pos.end())
            {
                para_pos[s] = max_index;
                pos_para[max_index] = s;
                max_index++;
            }
            arr.push_back(std::make_pair(para_pos[s], deter[i].second));
        }
        
        //按id排序
        sort(arr.begin(), arr.end(), MyLess);
        //去重,合并同变量系数
        int t = 0;
        for (i = 1; i < arr.size(); ++i)
        {
            if (arr[t].first == arr[i].first)
            {
                arr[t].second += arr[i].second;
            }
            else
            {
                arr[++t] = arr[i];
            }
        }
        for (++t; t < i; ++t)
            arr.pop_back();
        
        constraint c;
        c.determinant = arr;
        c.node = constant;
        c.messages = info;
        C.push_back(c);
        
        std::vector<constraint>::iterator cur = C.begin();
        std::vector<constraint>::iterator last = cur + C.size()-1;
        
        while (cur < last)
        {
            Sub(cur, last);
            if (last->determinant.size() == 0)
            {   //判冲突
                if (!last->node.IsZero())
                {
                    if (ambiguous)
                    {   //接受二义性
                        std::cout<<"waring: "<< info<<std::endl;
                    }
                    else
                    {   //不接受二义性
                        std::cout<<"error: "<< info<<std::endl;
                    }
                }
                C.erase(last);
                return;
            }
            ++cur;
        }
        
        double d = last->determinant[0].second;
        for (std::vector<opei>::iterator i= last->determinant.begin(); i<last->determinant.end(); ++i) {
            i->second /= d;
        }
        last->node = last->node.power(1/d);
        cur = C.begin();
        last = cur + C.size()-1;
        /*
         while (cur < last)
         {
         Sub(last, cur);
         ++cur;
         }
         */
    }
    
    /// <summary>
    /// 两约束相减，维护上三角矩阵
    /// </summary>
    /// <param name="node1"></param>
    /// <param name="node2"></param>
    void GauseSolver::Sub(std::vector<constraint>::iterator node1, std::vector<constraint>::iterator& node2)
    {
        std::vector<opei>::iterator ite1 = node1->determinant.begin();
        std::vector<opei>::iterator ite2 = node2->determinant.begin();
        
        for (ite1 = node1->determinant.begin(),ite2 = node2->determinant.begin();
             ite2 != node2->determinant.end(); ++ite2) {
            if(ite2->first == ite1->first)
                break;
        }
        if (ite2 == node2->determinant.end()) return;
        double d = ite2->second / ite1->second;
        
        ite1 = node1->determinant.begin();
        ite2 = node2->determinant.begin();
        while ( ite1!=node1->determinant.end() && ite2!=node2->determinant.end())
        {
            if (ite1->first == ite2->first)
            {
                ite2->second -= d* ite1->second;
                ++ite1;
                if (ite2->second == 0)
                    ite2 = node2->determinant.erase(ite2);
                else
                    ++ite2;
            }
            else if (ite1->first > ite2->first)
            {
                ++ite2;
            }
            else
            {
                //node2->determinant.List.AddBefore(node2->determinant, new WTuple<int, double>(node1->determinant.Value.Item1, -node1->determinant.Value.Item2 * d));
                opei p;
                p.first = ite1->first;
                p.second = ite1->second * d;
                ite2 = node2->determinant.insert(ite2, p);
                ++ite1;
                ++ite2;
            }
        }
        
        for (; ite1 != node1->determinant.end(); ++ite1)
        {
            opei p;
            p.first = ite1->first;
            p.second = ite1->second * d;
            node2->determinant.push_back(p);
        }
        
        node2->node = node2->node / node1->node.power(d);
    }
}
#endif /* defined(__TestLocal__dimension__) */

