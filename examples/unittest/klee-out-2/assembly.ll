; ModuleID = 'test1.o'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str2 = private constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str13 = private constant [15 x i8] c"divide by zero\00", align 1
@.str24 = private constant [8 x i8] c"div.err\00", align 1
@.str3 = private constant [8 x i8] c"IGNORED\00", align 1
@.str14 = private constant [16 x i8] c"overshift error\00", align 1
@.str25 = private constant [14 x i8] c"overshift.err\00", align 1
@.str6 = private constant [13 x i8] c"klee_range.c\00", align 1
@.str17 = private constant [14 x i8] c"invalid range\00", align 1
@.str28 = private constant [5 x i8] c"user\00", align 1

define i32 @fun1(i32 %x, i32 %y) nounwind {
entry:
  %x_addr = alloca i32, align 4
  %y_addr = alloca i32, align 4
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %x, i32* %x_addr
  store i32 %y, i32* %y_addr
  %1 = load i32* %x_addr, align 4, !dbg !126
  %2 = load i32* %y_addr, align 4, !dbg !126
  %3 = icmp sgt i32 %1, %2, !dbg !126
  br i1 %3, label %bb, label %bb1, !dbg !126

bb:                                               ; preds = %entry
  store i32 0, i32* %0, align 4, !dbg !128
  br label %bb4, !dbg !128

bb1:                                              ; preds = %entry
  %4 = load i32* %x_addr, align 4, !dbg !129
  %5 = load i32* %y_addr, align 4, !dbg !129
  %6 = icmp slt i32 %4, %5, !dbg !129
  br i1 %6, label %bb2, label %bb3, !dbg !129

bb2:                                              ; preds = %bb1
  store i32 -1, i32* %0, align 4, !dbg !130
  br label %bb4, !dbg !130

bb3:                                              ; preds = %bb1
  store i32 1, i32* %0, align 4, !dbg !131
  br label %bb4, !dbg !131

bb4:                                              ; preds = %bb3, %bb2, %bb
  %7 = load i32* %0, align 4, !dbg !128
  store i32 %7, i32* %retval, align 4, !dbg !128
  %retval5 = load i32* %retval, !dbg !128
  ret i32 %retval5, !dbg !128
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @fun2(i32 %x, i32 %y) nounwind {
entry:
  %x_addr = alloca i32, align 4
  %y_addr = alloca i32, align 4
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  store i32 %x, i32* %x_addr
  store i32 %y, i32* %y_addr
  %1 = load i32* %x_addr, align 4, !dbg !132
  %2 = icmp sgt i32 %1, 10, !dbg !132
  %3 = load i32* %x_addr, align 4, !dbg !134
  br i1 %2, label %bb, label %bb1, !dbg !132

bb:                                               ; preds = %entry
  %4 = add nsw i32 %3, 1, !dbg !134
  store i32 %4, i32* %x_addr, align 4, !dbg !134
  br label %bb2, !dbg !134

bb1:                                              ; preds = %entry
  %5 = sub nsw i32 %3, 1, !dbg !135
  store i32 %5, i32* %x_addr, align 4, !dbg !135
  br label %bb2, !dbg !135

bb2:                                              ; preds = %bb1, %bb
  %6 = load i32* %x_addr, align 4, !dbg !136
  %7 = load i32* %y_addr, align 4, !dbg !136
  %8 = call i32 @fun1(i32 %6, i32 %7) nounwind, !dbg !136
  store i32 %8, i32* %0, align 4, !dbg !136
  %9 = load i32* %0, align 4, !dbg !136
  store i32 %9, i32* %retval, align 4, !dbg !136
  %retval3 = load i32* %retval, !dbg !136
  ret i32 %retval3, !dbg !136
}

define i32 @main() nounwind {
entry:
  %retval = alloca i32
  %0 = alloca i32
  %a = alloca i32
  %b = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  %a1 = bitcast i32* %a to i8*, !dbg !137
  call void @klee_make_symbolic(i8* %a1, i64 4, i8* getelementptr inbounds ([2 x i8]* @.str, i64 0, i64 0)) nounwind, !dbg !137
  %b2 = bitcast i32* %b to i8*, !dbg !139
  call void @klee_make_symbolic(i8* %b2, i64 4, i8* getelementptr inbounds ([2 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !139
  %1 = load i32* %b, align 4, !dbg !140
  %2 = load i32* %a, align 4, !dbg !140
  %3 = call i32 @fun2(i32 %2, i32 %1) nounwind, !dbg !140
  store i32 %3, i32* %0, align 4, !dbg !140
  %4 = load i32* %0, align 4, !dbg !140
  store i32 %4, i32* %retval, align 4, !dbg !140
  %retval3 = load i32* %retval, !dbg !140
  ret i32 %retval3, !dbg !140
}

declare void @klee_make_symbolic(i8*, i64, i8*)

define void @klee_div_zero_check(i64 %z) nounwind {
entry:
  %0 = icmp eq i64 %z, 0, !dbg !141
  br i1 %0, label %bb, label %return, !dbg !141

bb:                                               ; preds = %entry
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str2, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str13, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8]* @.str24, i64 0, i64 0)) noreturn nounwind, !dbg
  unreachable, !dbg !143

return:                                           ; preds = %entry
  ret void, !dbg !144
}

declare void @klee_report_error(i8*, i32, i8*, i8*) noreturn

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define i32 @klee_int(i8* %name) nounwind {
entry:
  %x = alloca i32, align 4
  %x1 = bitcast i32* %x to i8*, !dbg !145
  call void @klee_make_symbolic(i8* %x1, i64 4, i8* %name) nounwind, !dbg !145
  %0 = load i32* %x, align 4, !dbg !146
  ret i32 %0, !dbg !146
}

define void @klee_overshift_check(i64 %bitWidth, i64 %shift) nounwind {
entry:
  %0 = icmp ult i64 %shift, %bitWidth, !dbg !147
  br i1 %0, label %return, label %bb, !dbg !147

bb:                                               ; preds = %entry
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str3, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str14, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str25, i64 0, i64 0)) noreturn nounwind, !dbg 
  unreachable, !dbg !149

return:                                           ; preds = %entry
  ret void, !dbg !150
}

define i32 @klee_range(i32 %start, i32 %end, i8* %name) nounwind {
entry:
  %x = alloca i32, align 4
  %0 = icmp slt i32 %start, %end, !dbg !151
  br i1 %0, label %bb1, label %bb, !dbg !151

bb:                                               ; preds = %entry
  call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str6, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str28, i64 0, i64 0)) noreturn nounwind, !dbg !152
  unreachable, !dbg !152

bb1:                                              ; preds = %entry
  %1 = add nsw i32 %start, 1, !dbg !153
  %2 = icmp eq i32 %1, %end, !dbg !153
  br i1 %2, label %bb8, label %bb3, !dbg !153

bb3:                                              ; preds = %bb1
  %x4 = bitcast i32* %x to i8*, !dbg !154
  call void @klee_make_symbolic(i8* %x4, i64 4, i8* %name) nounwind, !dbg !154
  %3 = icmp eq i32 %start, 0, !dbg !155
  %4 = load i32* %x, align 4, !dbg !156
  br i1 %3, label %bb5, label %bb6, !dbg !155

bb5:                                              ; preds = %bb3
  %5 = icmp ult i32 %4, %end, !dbg !156
  %6 = zext i1 %5 to i64, !dbg !156
  call void @klee_assume(i64 %6) nounwind, !dbg !156
  br label %bb7, !dbg !156

bb6:                                              ; preds = %bb3
  %7 = icmp sge i32 %4, %start, !dbg !157
  %8 = zext i1 %7 to i64, !dbg !157
  call void @klee_assume(i64 %8) nounwind, !dbg !157
  %9 = load i32* %x, align 4, !dbg !158
  %10 = icmp slt i32 %9, %end, !dbg !158
  %11 = zext i1 %10 to i64, !dbg !158
  call void @klee_assume(i64 %11) nounwind, !dbg !158
  br label %bb7, !dbg !158

bb7:                                              ; preds = %bb6, %bb5
  %12 = load i32* %x, align 4, !dbg !159
  br label %bb8, !dbg !159

bb8:                                              ; preds = %bb7, %bb1
  %.0 = phi i32 [ %12, %bb7 ], [ %start, %bb1 ]
  ret i32 %.0, !dbg !160
}

declare void @klee_assume(i64)

define weak i8* @mempcpy(i8* %destaddr, i8* %srcaddr, i64 %len) nounwind {
entry:
  %0 = icmp eq i64 %len, 0, !dbg !161
  br i1 %0, label %bb2, label %bb, !dbg !161

bb:                                               ; preds = %bb, %entry
  %indvar = phi i64 [ %indvar.next, %bb ], [ 0, %entry ]
  %dest.05 = getelementptr i8* %destaddr, i64 %indvar
  %src.06 = getelementptr i8* %srcaddr, i64 %indvar
  %1 = load i8* %src.06, align 1, !dbg !162
  store i8 %1, i8* %dest.05, align 1, !dbg !162
  %indvar.next = add i64 %indvar, 1
  %exitcond1 = icmp eq i64 %indvar.next, %len
  br i1 %exitcond1, label %bb1.bb2_crit_edge, label %bb, !dbg !161

bb1.bb2_crit_edge:                                ; preds = %bb
  %scevgep = getelementptr i8* %destaddr, i64 %len
  br label %bb2

bb2:                                              ; preds = %bb1.bb2_crit_edge, %entry
  %dest.0.lcssa = phi i8* [ %scevgep, %bb1.bb2_crit_edge ], [ %destaddr, %entry ]
  ret i8* %dest.0.lcssa, !dbg !163
}

!llvm.dbg.sp = !{!0, !6, !7, !10, !16, !25, !31, !40, !49, !58, !67}
!llvm.dbg.lv.klee_div_zero_check = !{!77}
!llvm.dbg.lv.klee_int = !{!78, !79}
!llvm.dbg.lv.klee_overshift_check = !{!81, !82}
!llvm.dbg.lv.klee_range = !{!83, !84, !85, !86}
!llvm.dbg.lv.memcpy = !{!88, !89, !90, !91, !95}
!llvm.dbg.lv.memmove = !{!98, !99, !100, !101, !105}
!llvm.dbg.lv.mempcpy = !{!108, !109, !110, !111, !115}
!llvm.dbg.lv.memset = !{!118, !119, !120, !121}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fun1", metadata !"fun1", metadata !"fun1", metadata !1, i32 7, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i32)* @fun1} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"test1.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/examples/unittest/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"test1.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/examples/unittest/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_com
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !5, metadata !5}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fun2", metadata !"fun2", metadata !"fun2", metadata !1, i32 17, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i32)* @fun2} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"main", metadata !1, i32 25, metadata !8, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!8 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !9, i32 0, null} ; [ DW_TAG_subroutine_type ]
!9 = metadata !{metadata !5}
!10 = metadata !{i32 589870, i32 0, metadata !11, metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !11, i32 12, metadata !13, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64)* 
!11 = metadata !{i32 589865, metadata !"klee_div_zero_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !12} ; [ DW_TAG_file_type ]
!12 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_div_zero_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} 
!13 = metadata !{i32 589845, metadata !11, metadata !"", metadata !11, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !14, i32 0, null} ; [ DW_TAG_subroutine_type ]
!14 = metadata !{null, metadata !15}
!15 = metadata !{i32 589860, metadata !11, metadata !"long long int", metadata !11, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!16 = metadata !{i32 589870, i32 0, metadata !17, metadata !"klee_int", metadata !"klee_int", metadata !"klee_int", metadata !17, i32 13, metadata !19, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @klee_int} ; [ DW_TAG_subprogram ]
!17 = metadata !{i32 589865, metadata !"klee_int.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !18} ; [ DW_TAG_file_type ]
!18 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_int.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_
!19 = metadata !{i32 589845, metadata !17, metadata !"", metadata !17, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !20, i32 0, null} ; [ DW_TAG_subroutine_type ]
!20 = metadata !{metadata !21, metadata !22}
!21 = metadata !{i32 589860, metadata !17, metadata !"int", metadata !17, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!22 = metadata !{i32 589839, metadata !17, metadata !"", metadata !17, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !23} ; [ DW_TAG_pointer_type ]
!23 = metadata !{i32 589862, metadata !17, metadata !"", metadata !17, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !24} ; [ DW_TAG_const_type ]
!24 = metadata !{i32 589860, metadata !17, metadata !"char", metadata !17, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!25 = metadata !{i32 589870, i32 0, metadata !26, metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !26, i32 20, metadata !28, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64
!26 = metadata !{i32 589865, metadata !"klee_overshift_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !27} ; [ DW_TAG_file_type ]
!27 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_overshift_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0}
!28 = metadata !{i32 589845, metadata !26, metadata !"", metadata !26, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !29, i32 0, null} ; [ DW_TAG_subroutine_type ]
!29 = metadata !{null, metadata !30, metadata !30}
!30 = metadata !{i32 589860, metadata !26, metadata !"long long unsigned int", metadata !26, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!31 = metadata !{i32 589870, i32 0, metadata !32, metadata !"klee_range", metadata !"klee_range", metadata !"klee_range", metadata !32, i32 13, metadata !34, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i8*)* @klee_range} ; [ D
!32 = metadata !{i32 589865, metadata !"klee_range.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !33} ; [ DW_TAG_file_type ]
!33 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_range.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TA
!34 = metadata !{i32 589845, metadata !32, metadata !"", metadata !32, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !35, i32 0, null} ; [ DW_TAG_subroutine_type ]
!35 = metadata !{metadata !36, metadata !36, metadata !36, metadata !37}
!36 = metadata !{i32 589860, metadata !32, metadata !"int", metadata !32, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!37 = metadata !{i32 589839, metadata !32, metadata !"", metadata !32, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !38} ; [ DW_TAG_pointer_type ]
!38 = metadata !{i32 589862, metadata !32, metadata !"", metadata !32, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !39} ; [ DW_TAG_const_type ]
!39 = metadata !{i32 589860, metadata !32, metadata !"char", metadata !32, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!40 = metadata !{i32 589870, i32 0, metadata !41, metadata !"memcpy", metadata !"memcpy", metadata !"memcpy", metadata !41, i32 12, metadata !43, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!41 = metadata !{i32 589865, metadata !"memcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !42} ; [ DW_TAG_file_type ]
!42 = metadata !{i32 589841, i32 0, i32 1, metadata !"memcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_co
!43 = metadata !{i32 589845, metadata !41, metadata !"", metadata !41, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !44, i32 0, null} ; [ DW_TAG_subroutine_type ]
!44 = metadata !{metadata !45, metadata !45, metadata !45, metadata !46}
!45 = metadata !{i32 589839, metadata !41, metadata !"", metadata !41, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!46 = metadata !{i32 589846, metadata !47, metadata !"size_t", metadata !47, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !48} ; [ DW_TAG_typedef ]
!47 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !42} ; [ DW_TAG_file_type ]
!48 = metadata !{i32 589860, metadata !41, metadata !"long unsigned int", metadata !41, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!49 = metadata !{i32 589870, i32 0, metadata !50, metadata !"memmove", metadata !"memmove", metadata !"memmove", metadata !50, i32 12, metadata !52, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!50 = metadata !{i32 589865, metadata !"memmove.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !51} ; [ DW_TAG_file_type ]
!51 = metadata !{i32 589841, i32 0, i32 1, metadata !"memmove.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_c
!52 = metadata !{i32 589845, metadata !50, metadata !"", metadata !50, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !53, i32 0, null} ; [ DW_TAG_subroutine_type ]
!53 = metadata !{metadata !54, metadata !54, metadata !54, metadata !55}
!54 = metadata !{i32 589839, metadata !50, metadata !"", metadata !50, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!55 = metadata !{i32 589846, metadata !56, metadata !"size_t", metadata !56, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !57} ; [ DW_TAG_typedef ]
!56 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !51} ; [ DW_TAG_file_type ]
!57 = metadata !{i32 589860, metadata !50, metadata !"long unsigned int", metadata !50, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!58 = metadata !{i32 589870, i32 0, metadata !59, metadata !"mempcpy", metadata !"mempcpy", metadata !"mempcpy", metadata !59, i32 11, metadata !61, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @mempcpy} ; [ DW_TAG_subpro
!59 = metadata !{i32 589865, metadata !"mempcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !60} ; [ DW_TAG_file_type ]
!60 = metadata !{i32 589841, i32 0, i32 1, metadata !"mempcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_c
!61 = metadata !{i32 589845, metadata !59, metadata !"", metadata !59, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !62, i32 0, null} ; [ DW_TAG_subroutine_type ]
!62 = metadata !{metadata !63, metadata !63, metadata !63, metadata !64}
!63 = metadata !{i32 589839, metadata !59, metadata !"", metadata !59, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!64 = metadata !{i32 589846, metadata !65, metadata !"size_t", metadata !65, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !66} ; [ DW_TAG_typedef ]
!65 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !60} ; [ DW_TAG_file_type ]
!66 = metadata !{i32 589860, metadata !59, metadata !"long unsigned int", metadata !59, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!67 = metadata !{i32 589870, i32 0, metadata !68, metadata !"memset", metadata !"memset", metadata !"memset", metadata !68, i32 11, metadata !70, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!68 = metadata !{i32 589865, metadata !"memset.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !69} ; [ DW_TAG_file_type ]
!69 = metadata !{i32 589841, i32 0, i32 1, metadata !"memset.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_co
!70 = metadata !{i32 589845, metadata !68, metadata !"", metadata !68, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !71, i32 0, null} ; [ DW_TAG_subroutine_type ]
!71 = metadata !{metadata !72, metadata !72, metadata !73, metadata !74}
!72 = metadata !{i32 589839, metadata !68, metadata !"", metadata !68, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!73 = metadata !{i32 589860, metadata !68, metadata !"int", metadata !68, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!74 = metadata !{i32 589846, metadata !75, metadata !"size_t", metadata !75, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !76} ; [ DW_TAG_typedef ]
!75 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !69} ; [ DW_TAG_file_type ]
!76 = metadata !{i32 589860, metadata !68, metadata !"long unsigned int", metadata !68, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!77 = metadata !{i32 590081, metadata !10, metadata !"z", metadata !11, i32 12, metadata !15, i32 0} ; [ DW_TAG_arg_variable ]
!78 = metadata !{i32 590081, metadata !16, metadata !"name", metadata !17, i32 13, metadata !22, i32 0} ; [ DW_TAG_arg_variable ]
!79 = metadata !{i32 590080, metadata !80, metadata !"x", metadata !17, i32 14, metadata !21, i32 0} ; [ DW_TAG_auto_variable ]
!80 = metadata !{i32 589835, metadata !16, i32 13, i32 0, metadata !17, i32 0} ; [ DW_TAG_lexical_block ]
!81 = metadata !{i32 590081, metadata !25, metadata !"bitWidth", metadata !26, i32 20, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!82 = metadata !{i32 590081, metadata !25, metadata !"shift", metadata !26, i32 20, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!83 = metadata !{i32 590081, metadata !31, metadata !"start", metadata !32, i32 13, metadata !36, i32 0} ; [ DW_TAG_arg_variable ]
!84 = metadata !{i32 590081, metadata !31, metadata !"end", metadata !32, i32 13, metadata !36, i32 0} ; [ DW_TAG_arg_variable ]
!85 = metadata !{i32 590081, metadata !31, metadata !"name", metadata !32, i32 13, metadata !37, i32 0} ; [ DW_TAG_arg_variable ]
!86 = metadata !{i32 590080, metadata !87, metadata !"x", metadata !32, i32 14, metadata !36, i32 0} ; [ DW_TAG_auto_variable ]
!87 = metadata !{i32 589835, metadata !31, i32 13, i32 0, metadata !32, i32 0} ; [ DW_TAG_lexical_block ]
!88 = metadata !{i32 590081, metadata !40, metadata !"destaddr", metadata !41, i32 12, metadata !45, i32 0} ; [ DW_TAG_arg_variable ]
!89 = metadata !{i32 590081, metadata !40, metadata !"srcaddr", metadata !41, i32 12, metadata !45, i32 0} ; [ DW_TAG_arg_variable ]
!90 = metadata !{i32 590081, metadata !40, metadata !"len", metadata !41, i32 12, metadata !46, i32 0} ; [ DW_TAG_arg_variable ]
!91 = metadata !{i32 590080, metadata !92, metadata !"dest", metadata !41, i32 13, metadata !93, i32 0} ; [ DW_TAG_auto_variable ]
!92 = metadata !{i32 589835, metadata !40, i32 12, i32 0, metadata !41, i32 0} ; [ DW_TAG_lexical_block ]
!93 = metadata !{i32 589839, metadata !41, metadata !"", metadata !41, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !94} ; [ DW_TAG_pointer_type ]
!94 = metadata !{i32 589860, metadata !41, metadata !"char", metadata !41, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!95 = metadata !{i32 590080, metadata !92, metadata !"src", metadata !41, i32 14, metadata !96, i32 0} ; [ DW_TAG_auto_variable ]
!96 = metadata !{i32 589839, metadata !41, metadata !"", metadata !41, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !97} ; [ DW_TAG_pointer_type ]
!97 = metadata !{i32 589862, metadata !41, metadata !"", metadata !41, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !94} ; [ DW_TAG_const_type ]
!98 = metadata !{i32 590081, metadata !49, metadata !"dst", metadata !50, i32 12, metadata !54, i32 0} ; [ DW_TAG_arg_variable ]
!99 = metadata !{i32 590081, metadata !49, metadata !"src", metadata !50, i32 12, metadata !54, i32 0} ; [ DW_TAG_arg_variable ]
!100 = metadata !{i32 590081, metadata !49, metadata !"count", metadata !50, i32 12, metadata !55, i32 0} ; [ DW_TAG_arg_variable ]
!101 = metadata !{i32 590080, metadata !102, metadata !"a", metadata !50, i32 13, metadata !103, i32 0} ; [ DW_TAG_auto_variable ]
!102 = metadata !{i32 589835, metadata !49, i32 12, i32 0, metadata !50, i32 0} ; [ DW_TAG_lexical_block ]
!103 = metadata !{i32 589839, metadata !50, metadata !"", metadata !50, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !104} ; [ DW_TAG_pointer_type ]
!104 = metadata !{i32 589860, metadata !50, metadata !"char", metadata !50, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!105 = metadata !{i32 590080, metadata !102, metadata !"b", metadata !50, i32 14, metadata !106, i32 0} ; [ DW_TAG_auto_variable ]
!106 = metadata !{i32 589839, metadata !50, metadata !"", metadata !50, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !107} ; [ DW_TAG_pointer_type ]
!107 = metadata !{i32 589862, metadata !50, metadata !"", metadata !50, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !104} ; [ DW_TAG_const_type ]
!108 = metadata !{i32 590081, metadata !58, metadata !"destaddr", metadata !59, i32 11, metadata !63, i32 0} ; [ DW_TAG_arg_variable ]
!109 = metadata !{i32 590081, metadata !58, metadata !"srcaddr", metadata !59, i32 11, metadata !63, i32 0} ; [ DW_TAG_arg_variable ]
!110 = metadata !{i32 590081, metadata !58, metadata !"len", metadata !59, i32 11, metadata !64, i32 0} ; [ DW_TAG_arg_variable ]
!111 = metadata !{i32 590080, metadata !112, metadata !"dest", metadata !59, i32 12, metadata !113, i32 0} ; [ DW_TAG_auto_variable ]
!112 = metadata !{i32 589835, metadata !58, i32 11, i32 0, metadata !59, i32 0} ; [ DW_TAG_lexical_block ]
!113 = metadata !{i32 589839, metadata !59, metadata !"", metadata !59, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !114} ; [ DW_TAG_pointer_type ]
!114 = metadata !{i32 589860, metadata !59, metadata !"char", metadata !59, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!115 = metadata !{i32 590080, metadata !112, metadata !"src", metadata !59, i32 13, metadata !116, i32 0} ; [ DW_TAG_auto_variable ]
!116 = metadata !{i32 589839, metadata !59, metadata !"", metadata !59, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !117} ; [ DW_TAG_pointer_type ]
!117 = metadata !{i32 589862, metadata !59, metadata !"", metadata !59, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !114} ; [ DW_TAG_const_type ]
!118 = metadata !{i32 590081, metadata !67, metadata !"dst", metadata !68, i32 11, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!119 = metadata !{i32 590081, metadata !67, metadata !"s", metadata !68, i32 11, metadata !73, i32 0} ; [ DW_TAG_arg_variable ]
!120 = metadata !{i32 590081, metadata !67, metadata !"count", metadata !68, i32 11, metadata !74, i32 0} ; [ DW_TAG_arg_variable ]
!121 = metadata !{i32 590080, metadata !122, metadata !"a", metadata !68, i32 12, metadata !123, i32 0} ; [ DW_TAG_auto_variable ]
!122 = metadata !{i32 589835, metadata !67, i32 11, i32 0, metadata !68, i32 0} ; [ DW_TAG_lexical_block ]
!123 = metadata !{i32 589839, metadata !68, metadata !"", metadata !68, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !124} ; [ DW_TAG_pointer_type ]
!124 = metadata !{i32 589877, metadata !68, metadata !"", metadata !68, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !125} ; [ DW_TAG_volatile_type ]
!125 = metadata !{i32 589860, metadata !68, metadata !"char", metadata !68, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!126 = metadata !{i32 8, i32 0, metadata !127, null}
!127 = metadata !{i32 589835, metadata !0, i32 7, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!128 = metadata !{i32 9, i32 0, metadata !127, null}
!129 = metadata !{i32 11, i32 0, metadata !127, null}
!130 = metadata !{i32 12, i32 0, metadata !127, null}
!131 = metadata !{i32 14, i32 0, metadata !127, null}
!132 = metadata !{i32 18, i32 0, metadata !133, null}
!133 = metadata !{i32 589835, metadata !6, i32 17, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!134 = metadata !{i32 19, i32 0, metadata !133, null}
!135 = metadata !{i32 21, i32 0, metadata !133, null}
!136 = metadata !{i32 22, i32 0, metadata !133, null}
!137 = metadata !{i32 28, i32 0, metadata !138, null}
!138 = metadata !{i32 589835, metadata !7, i32 25, i32 0, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!139 = metadata !{i32 29, i32 0, metadata !138, null}
!140 = metadata !{i32 30, i32 0, metadata !138, null}
!141 = metadata !{i32 13, i32 0, metadata !142, null}
!142 = metadata !{i32 589835, metadata !10, i32 12, i32 0, metadata !11, i32 0} ; [ DW_TAG_lexical_block ]
!143 = metadata !{i32 14, i32 0, metadata !142, null}
!144 = metadata !{i32 15, i32 0, metadata !142, null}
!145 = metadata !{i32 15, i32 0, metadata !80, null}
!146 = metadata !{i32 16, i32 0, metadata !80, null}
!147 = metadata !{i32 21, i32 0, metadata !148, null}
!148 = metadata !{i32 589835, metadata !25, i32 20, i32 0, metadata !26, i32 0} ; [ DW_TAG_lexical_block ]
!149 = metadata !{i32 27, i32 0, metadata !148, null}
!150 = metadata !{i32 29, i32 0, metadata !148, null}
!151 = metadata !{i32 16, i32 0, metadata !87, null}
!152 = metadata !{i32 17, i32 0, metadata !87, null}
!153 = metadata !{i32 19, i32 0, metadata !87, null}
!154 = metadata !{i32 22, i32 0, metadata !87, null}
!155 = metadata !{i32 25, i32 0, metadata !87, null}
!156 = metadata !{i32 26, i32 0, metadata !87, null}
!157 = metadata !{i32 28, i32 0, metadata !87, null}
!158 = metadata !{i32 29, i32 0, metadata !87, null}
!159 = metadata !{i32 32, i32 0, metadata !87, null}
!160 = metadata !{i32 20, i32 0, metadata !87, null}
!161 = metadata !{i32 15, i32 0, metadata !112, null}
!162 = metadata !{i32 16, i32 0, metadata !112, null}
!163 = metadata !{i32 17, i32 0, metadata !112, null}
