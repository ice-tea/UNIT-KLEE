//
//  dimension.h
//  TestLocal
//
//  Created by 李博 on 15/2/5.
//  Copyright (c) 2015年 Libo. All rights reserved.
//

#ifndef __TestLocal__dimension__
#define __TestLocal__dimension__

#include "klee/tinyxml.h"
#include <iostream>
#include <vector>
#include <algorithm>
#include <map>
#include <math.h>

namespace MyDim {
    class dimensionNode
    {
    private:
        std::string name;
    public:
        std::vector<float> dimension;
        float coefficient;
        float offset;
    public:
        dimensionNode()
        {
            this->name = "";
        }
        dimensionNode(std::string name)
        {
            this->name = name;
        }
        ~dimensionNode(){
            dimension.clear();
        }
        bool isEmpty(){
            return this->name == "error";
        }
        void setDimensionName(std::string name)
        {
            this->name = name;
        }
        void addDimension(float dimension)
        {
            this->dimension.push_back(dimension);
        }
        void addCoefficientAndOffset(float coefficient, float offset)
        {
            this->coefficient = coefficient;
            this->offset = offset;
        }
        //是否是无量纲类型
        bool IsZero()
        {
            for (int i = 0; i < this->dimension.size(); i++)
            {
                if(this->dimension[i] != 0)
                    return false;
            }
            return (this->coefficient == 1 && this->offset == 0);
        }
        void print()
        {
            if (!isEmpty())
            {
                std::cout<<"d:";
                for (int i = 0; i < this->dimension.size(); i++)
                {
                    std::cout<<this->dimension[i]<<",";
                }
                std::cout<<std::endl;
                std::cout<<"c:"<< this->coefficient<<"  ";
                std::cout<<"o:"<< this->offset;
            }
            else
            {
                std::cout<<"量纲为空！";
            }
            std::cout<<std::endl;
        }
    public:
        dimensionNode operator * (const dimensionNode& hs)
        {
            dimensionNode result;
            for (int i = 0; i < this->dimension.size(); i++)
            {
                result.addDimension(this->dimension[i] + hs.dimension[i]);
            }
            result.coefficient = this->coefficient * hs.coefficient;
            result.offset = this->offset + hs.offset;
            return result;
        }
        bool operator == (const dimensionNode& hs)
        {
            if ((this->offset != hs.offset) || (this->coefficient != hs.coefficient))
            {
                return false;
            }
            for (int i = 0; i < this->dimension.size(); i++)
            {
                if (this->dimension[i] != hs.dimension[i])
                {
                    return false;
                }
            }
            return true;
        }
        dimensionNode operator / (const dimensionNode& hs)
        {
            dimensionNode result;
            for (int i = 0; i < this->dimension.size(); i++)
            {
                result.addDimension(this->dimension[i] - hs.dimension[i]);
            }
            result.coefficient = this->coefficient / hs.coefficient;
            result.offset = this->offset - hs.offset;
            return result;
        }
        dimensionNode power (const double p)
        {
            dimensionNode result;
            for (int i = 0; i < this->dimension.size(); i++)
            {
                result.addDimension(this->dimension[i] * p);
            }
            result.coefficient = pow(this->coefficient, p);
            result.offset = this->offset * p;
            return result;
        }
    };
    
    
    class dimension
    {
    private:
        std::string xmlPath;
        std::map<std::string, dimensionNode> resultTable;
        
    public:
	dimension()
        {
            xmlPath = "dimension.xml";
            getBaseDimension();
            //getExtDimension();
        }
        dimension(std::string path)
        {
            xmlPath = path;
            getBaseDimension();
            //getExtDimension();
        }
        dimensionNode getDimension(std::string dimName);//使用该方法获取量纲节点
        
    private:
        bool getBaseDimension();//读取xml基础量纲
    };
    typedef std::pair<std::string, double> ope;
    typedef std::pair<int, double> opei;
    static bool MyLess(const opei& lhs, const opei& rhs)
    {
        return lhs.first < rhs.first;
    }
    /*
     约束矩阵描述
     +---+-----+    +---+-----+               +-------+
     | i | Coe | -> | j | Coe | ...    <=>    | const |      <=>     对应信息
     +---+-----+    +---+-----+               +-------+
     ...
     ...
     */
    typedef struct{
        std::vector<opei> determinant;
        dimensionNode node;
        std::string messages;
    } constraint;
    
    class GauseSolver
    {
    private:
        //记录变量名与其对应的位置
        std::map<std::string, int> para_pos;
        // 记录位置id与其对应的变量名
        std::map<int, std::string> pos_para;
        int max_index = 0;
        
        std::vector<constraint> C;
        
    public:
        GauseSolver(){}
        
        /*  copy constuct
         GauseSolver(GauseSolver solver)
         {
         foreach (KeyValuePair<string, int> pair in solver.para_pos)
         this.para_pos[pair.Key] = pair.Value;
         foreach (KeyValuePair<int, string> pair in solver.pos_para)
         this.pos_para[pair.Key] = pair.Value;
         this.max_index = solver.max_index;
         foreach (WTuple<LinkedList<WTuple<int, double>>, DNode, string> c in solver.C)
         {
         LinkedList<WTuple<int, double>> list = new LinkedList<WTuple<int, double>>();
         this.C.AddLast(new WTuple<LinkedList<WTuple<int, double>>, DNode, string>(list, new DNode(c.Item2), c.Item3));
         foreach (WTuple<int, double> pair in c.Item1)
         this.C.Last.Value.Item1.AddLast(new WTuple<int, double>(pair.Item1, pair.Item2));
         }
         }
         */
        
        /// <summary>
        /// 添加约束 a1*x1+a2*x2+...+an*xn = constant
        /// </summary>
        /// <param name="constraint">[集合]变量名 => 系数</param>
        /// <param name="constant">常数项（于等式右）</param>
        /// <param name="info">该约束对应的信息</param>
        /// <param name="ambiguous">是否接受二义性</param>
        void AddConstraint(std::vector<ope> deter, dimensionNode constant, std::string info = "", bool ambiguous = false);
    private:
        /// <summary>
        /// 两约束相减，维护上三角矩阵
        /// </summary>
        /// <param name="node1"></param>
        /// <param name="node2"></param>
        void Sub(std::vector<constraint>::iterator node1, std::vector<constraint>::iterator& node2);
    };
}
#endif /* defined(__TestLocal__dimension__) */

