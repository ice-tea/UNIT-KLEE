; ModuleID = 'klee_overshift_check.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"IGNORED\00", align 1
@.str1 = private unnamed_addr constant [16 x i8] c"overshift error\00", align 1
@.str2 = private unnamed_addr constant [14 x i8] c"overshift.err\00", align 1

define void @klee_overshift_check(i64 %bitWidth, i64 %shift) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i64 %bitWidth}, i64 0, metadata !6), !dbg !8
  tail call void @llvm.dbg.value(metadata !{i64 %shift}, i64 0, metadata !7), !dbg !8
  %0 = icmp ult i64 %shift, %bitWidth, !dbg !9
  br i1 %0, label %return, label %bb, !dbg !9

bb:                                               ; preds = %entry
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str2, i64 0, i64 0)) noreturn nounwind, !dbg !11
  unreachable, !dbg !11

return:                                           ; preds = %entry
  ret void, !dbg !12
}

declare void @klee_report_error(i8*, i32, i8*, i8*) noreturn

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.klee_overshift_check = !{!6, !7}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !1, i32 20, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64, i64)* @klee_overshift_check} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"klee_overshift_check.c", metadata !"/home/bo/workspace/klee-g/UNIT-KLEE/runtime/Intrinsic/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_overshift_check.c", metadata !"/home/bo/workspace/klee-g/UNIT-KLEE/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{null, metadata !5, metadata !5}
!5 = metadata !{i32 589860, metadata !1, metadata !"long long unsigned int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 590081, metadata !0, metadata !"bitWidth", metadata !1, i32 20, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!7 = metadata !{i32 590081, metadata !0, metadata !"shift", metadata !1, i32 20, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!8 = metadata !{i32 20, i32 0, metadata !0, null}
!9 = metadata !{i32 21, i32 0, metadata !10, null}
!10 = metadata !{i32 589835, metadata !0, i32 20, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!11 = metadata !{i32 27, i32 0, metadata !10, null}
!12 = metadata !{i32 29, i32 0, metadata !10, null}
