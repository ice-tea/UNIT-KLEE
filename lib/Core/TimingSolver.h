//===-- TimingSolver.h ------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_TIMINGSOLVER_H
#define KLEE_TIMINGSOLVER_H

#include "klee/Expr.h"
#include "klee/Solver.h"

#include <vector>

namespace klee {
  class ExecutionState;
  class Solver;  

  /// TimingSolver - A simple class which wraps a solver and handles
  /// tracking the statistics that we care about.
  class TimingSolver {
  public:
    Solver *solver;
    bool simplifyExprs;

  public:
    /// TimingSolver - Construct a new timing solver.
    ///
    /// \param _simplifyExprs - Whether expressions should be
    /// simplified (via the constraint manager interface) prior to
    /// querying.
    TimingSolver(Solver *_solver, bool _simplifyExprs = true) 
      : solver(_solver), simplifyExprs(_simplifyExprs) {}
    ~TimingSolver() {
      delete solver;
    }

    struct MyEdge{
    	int from;
    	int to;
    	MyEdge(int a,int b){
    		from =a;
    		to = b;
    	}
    	void tostring(){
    		char s[50];
    		sprintf(s, "%d to %d", from,to);
    	}
    };
    //libo
      public:
          	  std::set<MyEdge> CoverageBranch;
              std::set<MyEdge> AllBranchLines;
              //static bool branch_flag = false;
              bool branch_more = false;
              void addBranchLine(int i,int j){
            	  MyEdge e(i,j);
            	  AllBranchLines.insert(e);
              }
              //libo
                void addCoverageBranch(int i,int j){
                	MyEdge e(i,j);
                	CoverageBranch.insert(e);
                }
                double getCoveragePre(){
              	  return CoverageBranch.size()/AllBranchLines.size();
                }
                //~
              //~
        //~
    void setTimeout(double t) {
      solver->setCoreSolverTimeout(t);
    }
    
    char *getConstraintLog(const Query& query) {
      return solver->getConstraintLog(query);
    }

    bool evaluate(const ExecutionState&, ref<Expr>, Solver::Validity &result);

    bool mustBeTrue(const ExecutionState&, ref<Expr>, bool &result);

    bool mustBeFalse(const ExecutionState&, ref<Expr>, bool &result);

    bool mayBeTrue(const ExecutionState&, ref<Expr>, bool &result);

    bool mayBeFalse(const ExecutionState&, ref<Expr>, bool &result);

    bool getValue(const ExecutionState &, ref<Expr> expr, 
                  ref<ConstantExpr> &result);

    bool getInitialValues(const ExecutionState&, 
                          const std::vector<const Array*> &objects,
                          std::vector< std::vector<unsigned char> > &result);

    std::pair< ref<Expr>, ref<Expr> >
    getRange(const ExecutionState&, ref<Expr> query);
  };

}

#endif
