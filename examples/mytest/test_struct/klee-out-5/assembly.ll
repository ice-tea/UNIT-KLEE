; ModuleID = 'struct.o'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.f = type { i32, i32, %struct.f* }
%struct.ff = type { i32, %struct.f, %struct.f*, %struct.ff* }

@.str = private unnamed_addr constant [9 x i8] c"mystruct\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"mm\00", align 1
@.str2 = private constant [22 x i8] c"klee_div_zero_check.c\00", align 1
@.str13 = private constant [15 x i8] c"divide by zero\00", align 1
@.str24 = private constant [8 x i8] c"div.err\00", align 1
@.str3 = private constant [8 x i8] c"IGNORED\00", align 1
@.str14 = private constant [16 x i8] c"overshift error\00", align 1
@.str25 = private constant [14 x i8] c"overshift.err\00", align 1
@.str6 = private constant [13 x i8] c"klee_range.c\00", align 1
@.str17 = private constant [14 x i8] c"invalid range\00", align 1
@.str28 = private constant [5 x i8] c"user\00", align 1

define i32 @get_sign(%struct.ff* byval %s) nounwind {
entry:
  %retval = alloca i32
  %0 = alloca i32
  %"alloca point" = bitcast i32 0 to i32
  %1 = getelementptr inbounds %struct.ff* %s, i32 0, i32 0, !dbg !141
  %2 = load i32* %1, align 8, !dbg !141
  %3 = getelementptr inbounds %struct.ff* %s, i32 0, i32 1, !dbg !141
  %4 = getelementptr inbounds %struct.f* %3, i32 0, i32 0, !dbg !141
  %5 = load i32* %4, align 8, !dbg !141
  %6 = icmp sgt i32 %2, %5, !dbg !141
  br i1 %6, label %bb, label %bb1, !dbg !141

bb:                                               ; preds = %entry
  store i32 0, i32* %0, align 4, !dbg !143
  br label %bb4, !dbg !143

bb1:                                              ; preds = %entry
  %7 = getelementptr inbounds %struct.ff* %s, i32 0, i32 0, !dbg !144
  %8 = load i32* %7, align 8, !dbg !144
  %9 = getelementptr inbounds %struct.ff* %s, i32 0, i32 1, !dbg !144
  %10 = getelementptr inbounds %struct.f* %9, i32 0, i32 0, !dbg !144
  %11 = load i32* %10, align 8, !dbg !144
  %12 = icmp slt i32 %8, %11, !dbg !144
  br i1 %12, label %bb2, label %bb3, !dbg !144

bb2:                                              ; preds = %bb1
  store i32 -1, i32* %0, align 4, !dbg !145
  br label %bb4, !dbg !145

bb3:                                              ; preds = %bb1
  store i32 1, i32* %0, align 4, !dbg !146
  br label %bb4, !dbg !146

bb4:                                              ; preds = %bb3, %bb2, %bb
  %13 = load i32* %0, align 4, !dbg !143
  store i32 %13, i32* %retval, align 4, !dbg !143
  %retval5 = load i32* %retval, !dbg !143
  ret i32 %retval5, !dbg !143
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main() nounwind {
entry:
  %retval = alloca i32
  %0 = alloca i32
  %mystruct = alloca %struct.ff
  %mm = alloca %struct.f
  %"alloca point" = bitcast i32 0 to i32
  %mystruct1 = bitcast %struct.ff* %mystruct to i8*, !dbg !147
  call void @klee_make_symbolic(i8* %mystruct1, i64 40, i8* getelementptr inbounds ([9 x i8]* @.str, i64 0, i64 0)) nounwind, !dbg !147
  %mm2 = bitcast %struct.f* %mm to i8*, !dbg !149
  call void @klee_make_symbolic(i8* %mm2, i64 16, i8* getelementptr inbounds ([3 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !149
  %1 = call i32 @get_sign(%struct.ff* byval %mystruct) nounwind, !dbg !150
  store i32 %1, i32* %0, align 4, !dbg !150
  %2 = load i32* %0, align 4, !dbg !150
  store i32 %2, i32* %retval, align 4, !dbg !150
  %retval3 = load i32* %retval, !dbg !150
  ret i32 %retval3, !dbg !150
}

declare void @klee_make_symbolic(i8*, i64, i8*)

define void @klee_div_zero_check(i64 %z) nounwind {
entry:
  %0 = icmp eq i64 %z, 0, !dbg !151
  br i1 %0, label %bb, label %return, !dbg !151

bb:                                               ; preds = %entry
  tail call void @klee_report_error(i8* getelementptr inbounds ([22 x i8]* @.str2, i64 0, i64 0), i32 14, i8* getelementptr inbounds ([15 x i8]* @.str13, i64 0, i64 0), i8* getelementptr inbounds ([8 x i8]* @.str24, i64 0, i64 0)) noreturn nounwind, !dbg
  unreachable, !dbg !153

return:                                           ; preds = %entry
  ret void, !dbg !154
}

declare void @klee_report_error(i8*, i32, i8*, i8*) noreturn

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define i32 @klee_int(i8* %name) nounwind {
entry:
  %x = alloca i32, align 4
  %x1 = bitcast i32* %x to i8*, !dbg !155
  call void @klee_make_symbolic(i8* %x1, i64 4, i8* %name) nounwind, !dbg !155
  %0 = load i32* %x, align 4, !dbg !156
  ret i32 %0, !dbg !156
}

define void @klee_overshift_check(i64 %bitWidth, i64 %shift) nounwind {
entry:
  %0 = icmp ult i64 %shift, %bitWidth, !dbg !157
  br i1 %0, label %return, label %bb, !dbg !157

bb:                                               ; preds = %entry
  tail call void @klee_report_error(i8* getelementptr inbounds ([8 x i8]* @.str3, i64 0, i64 0), i32 0, i8* getelementptr inbounds ([16 x i8]* @.str14, i64 0, i64 0), i8* getelementptr inbounds ([14 x i8]* @.str25, i64 0, i64 0)) noreturn nounwind, !dbg 
  unreachable, !dbg !159

return:                                           ; preds = %entry
  ret void, !dbg !160
}

define i32 @klee_range(i32 %start, i32 %end, i8* %name) nounwind {
entry:
  %x = alloca i32, align 4
  %0 = icmp slt i32 %start, %end, !dbg !161
  br i1 %0, label %bb1, label %bb, !dbg !161

bb:                                               ; preds = %entry
  call void @klee_report_error(i8* getelementptr inbounds ([13 x i8]* @.str6, i64 0, i64 0), i32 17, i8* getelementptr inbounds ([14 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str28, i64 0, i64 0)) noreturn nounwind, !dbg !162
  unreachable, !dbg !162

bb1:                                              ; preds = %entry
  %1 = add nsw i32 %start, 1, !dbg !163
  %2 = icmp eq i32 %1, %end, !dbg !163
  br i1 %2, label %bb8, label %bb3, !dbg !163

bb3:                                              ; preds = %bb1
  %x4 = bitcast i32* %x to i8*, !dbg !164
  call void @klee_make_symbolic(i8* %x4, i64 4, i8* %name) nounwind, !dbg !164
  %3 = icmp eq i32 %start, 0, !dbg !165
  %4 = load i32* %x, align 4, !dbg !166
  br i1 %3, label %bb5, label %bb6, !dbg !165

bb5:                                              ; preds = %bb3
  %5 = icmp ult i32 %4, %end, !dbg !166
  %6 = zext i1 %5 to i64, !dbg !166
  call void @klee_assume(i64 %6) nounwind, !dbg !166
  br label %bb7, !dbg !166

bb6:                                              ; preds = %bb3
  %7 = icmp sge i32 %4, %start, !dbg !167
  %8 = zext i1 %7 to i64, !dbg !167
  call void @klee_assume(i64 %8) nounwind, !dbg !167
  %9 = load i32* %x, align 4, !dbg !168
  %10 = icmp slt i32 %9, %end, !dbg !168
  %11 = zext i1 %10 to i64, !dbg !168
  call void @klee_assume(i64 %11) nounwind, !dbg !168
  br label %bb7, !dbg !168

bb7:                                              ; preds = %bb6, %bb5
  %12 = load i32* %x, align 4, !dbg !169
  br label %bb8, !dbg !169

bb8:                                              ; preds = %bb7, %bb1
  %.0 = phi i32 [ %12, %bb7 ], [ %start, %bb1 ]
  ret i32 %.0, !dbg !170
}

declare void @klee_assume(i64)

define weak i8* @mempcpy(i8* %destaddr, i8* %srcaddr, i64 %len) nounwind {
entry:
  %0 = icmp eq i64 %len, 0, !dbg !171
  br i1 %0, label %bb2, label %bb, !dbg !171

bb:                                               ; preds = %bb, %entry
  %indvar = phi i64 [ %indvar.next, %bb ], [ 0, %entry ]
  %dest.05 = getelementptr i8* %destaddr, i64 %indvar
  %src.06 = getelementptr i8* %srcaddr, i64 %indvar
  %1 = load i8* %src.06, align 1, !dbg !172
  store i8 %1, i8* %dest.05, align 1, !dbg !172
  %indvar.next = add i64 %indvar, 1
  %exitcond1 = icmp eq i64 %indvar.next, %len
  br i1 %exitcond1, label %bb1.bb2_crit_edge, label %bb, !dbg !171

bb1.bb2_crit_edge:                                ; preds = %bb
  %scevgep = getelementptr i8* %destaddr, i64 %len
  br label %bb2

bb2:                                              ; preds = %bb1.bb2_crit_edge, %entry
  %dest.0.lcssa = phi i8* [ %scevgep, %bb1.bb2_crit_edge ], [ %destaddr, %entry ]
  ret i8* %dest.0.lcssa, !dbg !173
}

!llvm.dbg.sp = !{!0, !22, !25, !31, !40, !46, !55, !64, !73, !82}
!llvm.dbg.lv.klee_div_zero_check = !{!92}
!llvm.dbg.lv.klee_int = !{!93, !94}
!llvm.dbg.lv.klee_overshift_check = !{!96, !97}
!llvm.dbg.lv.klee_range = !{!98, !99, !100, !101}
!llvm.dbg.lv.memcpy = !{!103, !104, !105, !106, !110}
!llvm.dbg.lv.memmove = !{!113, !114, !115, !116, !120}
!llvm.dbg.lv.mempcpy = !{!123, !124, !125, !126, !130}
!llvm.dbg.lv.memset = !{!133, !134, !135, !136}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"get_sign", metadata !"get_sign", metadata !"get_sign", metadata !1, i32 20, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (%struct.ff*)* @get_sign} ; [ DW_TAG_subprog
!1 = metadata !{i32 589865, metadata !"struct.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/examples/mytest/test_struct/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"struct.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/examples/mytest/test_struct/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 false, metadata !"", i32 0} ; [
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589846, metadata !1, metadata !"ff", metadata !1, i32 19, i64 0, i64 0, i64 0, i32 0, metadata !7} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589843, metadata !1, metadata !"complex", metadata !1, i32 14, i64 320, i64 64, i64 0, i32 0, null, metadata !8, i32 0, null} ; [ DW_TAG_structure_type ]
!8 = metadata !{metadata !9, metadata !10, metadata !18, metadata !20}
!9 = metadata !{i32 589837, metadata !7, metadata !"a", metadata !1, i32 15, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_member ]
!10 = metadata !{i32 589837, metadata !7, metadata !"b", metadata !1, i32 16, i64 128, i64 64, i64 64, i32 0, metadata !11} ; [ DW_TAG_member ]
!11 = metadata !{i32 589846, metadata !1, metadata !"f", metadata !1, i32 12, i64 0, i64 0, i64 0, i32 0, metadata !12} ; [ DW_TAG_typedef ]
!12 = metadata !{i32 589843, metadata !1, metadata !"first", metadata !1, i32 8, i64 128, i64 64, i64 0, i32 0, null, metadata !13, i32 0, null} ; [ DW_TAG_structure_type ]
!13 = metadata !{metadata !14, metadata !15, metadata !16}
!14 = metadata !{i32 589837, metadata !12, metadata !"a", metadata !1, i32 9, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_member ]
!15 = metadata !{i32 589837, metadata !12, metadata !"b", metadata !1, i32 10, i64 32, i64 32, i64 32, i32 0, metadata !5} ; [ DW_TAG_member ]
!16 = metadata !{i32 589837, metadata !12, metadata !"c", metadata !1, i32 11, i64 64, i64 64, i64 64, i32 0, metadata !17} ; [ DW_TAG_member ]
!17 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !12} ; [ DW_TAG_pointer_type ]
!18 = metadata !{i32 589837, metadata !7, metadata !"c", metadata !1, i32 17, i64 64, i64 64, i64 192, i32 0, metadata !19} ; [ DW_TAG_member ]
!19 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!20 = metadata !{i32 589837, metadata !7, metadata !"d", metadata !1, i32 18, i64 64, i64 64, i64 256, i32 0, metadata !21} ; [ DW_TAG_member ]
!21 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!22 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"main", metadata !1, i32 30, metadata !23, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!23 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !24, i32 0, null} ; [ DW_TAG_subroutine_type ]
!24 = metadata !{metadata !5}
!25 = metadata !{i32 589870, i32 0, metadata !26, metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !"klee_div_zero_check", metadata !26, i32 12, metadata !28, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64)* 
!26 = metadata !{i32 589865, metadata !"klee_div_zero_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !27} ; [ DW_TAG_file_type ]
!27 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_div_zero_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} 
!28 = metadata !{i32 589845, metadata !26, metadata !"", metadata !26, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !29, i32 0, null} ; [ DW_TAG_subroutine_type ]
!29 = metadata !{null, metadata !30}
!30 = metadata !{i32 589860, metadata !26, metadata !"long long int", metadata !26, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!31 = metadata !{i32 589870, i32 0, metadata !32, metadata !"klee_int", metadata !"klee_int", metadata !"klee_int", metadata !32, i32 13, metadata !34, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @klee_int} ; [ DW_TAG_subprogram ]
!32 = metadata !{i32 589865, metadata !"klee_int.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !33} ; [ DW_TAG_file_type ]
!33 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_int.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_
!34 = metadata !{i32 589845, metadata !32, metadata !"", metadata !32, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !35, i32 0, null} ; [ DW_TAG_subroutine_type ]
!35 = metadata !{metadata !36, metadata !37}
!36 = metadata !{i32 589860, metadata !32, metadata !"int", metadata !32, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!37 = metadata !{i32 589839, metadata !32, metadata !"", metadata !32, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !38} ; [ DW_TAG_pointer_type ]
!38 = metadata !{i32 589862, metadata !32, metadata !"", metadata !32, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !39} ; [ DW_TAG_const_type ]
!39 = metadata !{i32 589860, metadata !32, metadata !"char", metadata !32, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!40 = metadata !{i32 589870, i32 0, metadata !41, metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !"klee_overshift_check", metadata !41, i32 20, metadata !43, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i64
!41 = metadata !{i32 589865, metadata !"klee_overshift_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !42} ; [ DW_TAG_file_type ]
!42 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_overshift_check.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0}
!43 = metadata !{i32 589845, metadata !41, metadata !"", metadata !41, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !44, i32 0, null} ; [ DW_TAG_subroutine_type ]
!44 = metadata !{null, metadata !45, metadata !45}
!45 = metadata !{i32 589860, metadata !41, metadata !"long long unsigned int", metadata !41, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!46 = metadata !{i32 589870, i32 0, metadata !47, metadata !"klee_range", metadata !"klee_range", metadata !"klee_range", metadata !47, i32 13, metadata !49, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i8*)* @klee_range} ; [ D
!47 = metadata !{i32 589865, metadata !"klee_range.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !48} ; [ DW_TAG_file_type ]
!48 = metadata !{i32 589841, i32 0, i32 1, metadata !"klee_range.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TA
!49 = metadata !{i32 589845, metadata !47, metadata !"", metadata !47, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !50, i32 0, null} ; [ DW_TAG_subroutine_type ]
!50 = metadata !{metadata !51, metadata !51, metadata !51, metadata !52}
!51 = metadata !{i32 589860, metadata !47, metadata !"int", metadata !47, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!52 = metadata !{i32 589839, metadata !47, metadata !"", metadata !47, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !53} ; [ DW_TAG_pointer_type ]
!53 = metadata !{i32 589862, metadata !47, metadata !"", metadata !47, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !54} ; [ DW_TAG_const_type ]
!54 = metadata !{i32 589860, metadata !47, metadata !"char", metadata !47, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!55 = metadata !{i32 589870, i32 0, metadata !56, metadata !"memcpy", metadata !"memcpy", metadata !"memcpy", metadata !56, i32 12, metadata !58, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!56 = metadata !{i32 589865, metadata !"memcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !57} ; [ DW_TAG_file_type ]
!57 = metadata !{i32 589841, i32 0, i32 1, metadata !"memcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_co
!58 = metadata !{i32 589845, metadata !56, metadata !"", metadata !56, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !59, i32 0, null} ; [ DW_TAG_subroutine_type ]
!59 = metadata !{metadata !60, metadata !60, metadata !60, metadata !61}
!60 = metadata !{i32 589839, metadata !56, metadata !"", metadata !56, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!61 = metadata !{i32 589846, metadata !62, metadata !"size_t", metadata !62, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !63} ; [ DW_TAG_typedef ]
!62 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !57} ; [ DW_TAG_file_type ]
!63 = metadata !{i32 589860, metadata !56, metadata !"long unsigned int", metadata !56, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!64 = metadata !{i32 589870, i32 0, metadata !65, metadata !"memmove", metadata !"memmove", metadata !"memmove", metadata !65, i32 12, metadata !67, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!65 = metadata !{i32 589865, metadata !"memmove.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !66} ; [ DW_TAG_file_type ]
!66 = metadata !{i32 589841, i32 0, i32 1, metadata !"memmove.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_c
!67 = metadata !{i32 589845, metadata !65, metadata !"", metadata !65, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !68, i32 0, null} ; [ DW_TAG_subroutine_type ]
!68 = metadata !{metadata !69, metadata !69, metadata !69, metadata !70}
!69 = metadata !{i32 589839, metadata !65, metadata !"", metadata !65, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!70 = metadata !{i32 589846, metadata !71, metadata !"size_t", metadata !71, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !72} ; [ DW_TAG_typedef ]
!71 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !66} ; [ DW_TAG_file_type ]
!72 = metadata !{i32 589860, metadata !65, metadata !"long unsigned int", metadata !65, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!73 = metadata !{i32 589870, i32 0, metadata !74, metadata !"mempcpy", metadata !"mempcpy", metadata !"mempcpy", metadata !74, i32 11, metadata !76, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i8*, i64)* @mempcpy} ; [ DW_TAG_subpro
!74 = metadata !{i32 589865, metadata !"mempcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !75} ; [ DW_TAG_file_type ]
!75 = metadata !{i32 589841, i32 0, i32 1, metadata !"mempcpy.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_c
!76 = metadata !{i32 589845, metadata !74, metadata !"", metadata !74, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !77, i32 0, null} ; [ DW_TAG_subroutine_type ]
!77 = metadata !{metadata !78, metadata !78, metadata !78, metadata !79}
!78 = metadata !{i32 589839, metadata !74, metadata !"", metadata !74, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!79 = metadata !{i32 589846, metadata !80, metadata !"size_t", metadata !80, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !81} ; [ DW_TAG_typedef ]
!80 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !75} ; [ DW_TAG_file_type ]
!81 = metadata !{i32 589860, metadata !74, metadata !"long unsigned int", metadata !74, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!82 = metadata !{i32 589870, i32 0, metadata !83, metadata !"memset", metadata !"memset", metadata !"memset", metadata !83, i32 11, metadata !85, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!83 = metadata !{i32 589865, metadata !"memset.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !84} ; [ DW_TAG_file_type ]
!84 = metadata !{i32 589841, i32 0, i32 1, metadata !"memset.c", metadata !"/home/bo/workspace/MyKlee/klee-copy/runtime/Intrinsic/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_co
!85 = metadata !{i32 589845, metadata !83, metadata !"", metadata !83, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !86, i32 0, null} ; [ DW_TAG_subroutine_type ]
!86 = metadata !{metadata !87, metadata !87, metadata !88, metadata !89}
!87 = metadata !{i32 589839, metadata !83, metadata !"", metadata !83, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!88 = metadata !{i32 589860, metadata !83, metadata !"int", metadata !83, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!89 = metadata !{i32 589846, metadata !90, metadata !"size_t", metadata !90, i32 326, i64 0, i64 0, i64 0, i32 0, metadata !91} ; [ DW_TAG_typedef ]
!90 = metadata !{i32 589865, metadata !"stddef.h", metadata !"/home/bo/Tools/llvm-gcc4.2-2.9-x86_64-linux/bin/../lib/gcc/x86_64-unknown-linux-gnu/4.2.1/include", metadata !84} ; [ DW_TAG_file_type ]
!91 = metadata !{i32 589860, metadata !83, metadata !"long unsigned int", metadata !83, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!92 = metadata !{i32 590081, metadata !25, metadata !"z", metadata !26, i32 12, metadata !30, i32 0} ; [ DW_TAG_arg_variable ]
!93 = metadata !{i32 590081, metadata !31, metadata !"name", metadata !32, i32 13, metadata !37, i32 0} ; [ DW_TAG_arg_variable ]
!94 = metadata !{i32 590080, metadata !95, metadata !"x", metadata !32, i32 14, metadata !36, i32 0} ; [ DW_TAG_auto_variable ]
!95 = metadata !{i32 589835, metadata !31, i32 13, i32 0, metadata !32, i32 0} ; [ DW_TAG_lexical_block ]
!96 = metadata !{i32 590081, metadata !40, metadata !"bitWidth", metadata !41, i32 20, metadata !45, i32 0} ; [ DW_TAG_arg_variable ]
!97 = metadata !{i32 590081, metadata !40, metadata !"shift", metadata !41, i32 20, metadata !45, i32 0} ; [ DW_TAG_arg_variable ]
!98 = metadata !{i32 590081, metadata !46, metadata !"start", metadata !47, i32 13, metadata !51, i32 0} ; [ DW_TAG_arg_variable ]
!99 = metadata !{i32 590081, metadata !46, metadata !"end", metadata !47, i32 13, metadata !51, i32 0} ; [ DW_TAG_arg_variable ]
!100 = metadata !{i32 590081, metadata !46, metadata !"name", metadata !47, i32 13, metadata !52, i32 0} ; [ DW_TAG_arg_variable ]
!101 = metadata !{i32 590080, metadata !102, metadata !"x", metadata !47, i32 14, metadata !51, i32 0} ; [ DW_TAG_auto_variable ]
!102 = metadata !{i32 589835, metadata !46, i32 13, i32 0, metadata !47, i32 0} ; [ DW_TAG_lexical_block ]
!103 = metadata !{i32 590081, metadata !55, metadata !"destaddr", metadata !56, i32 12, metadata !60, i32 0} ; [ DW_TAG_arg_variable ]
!104 = metadata !{i32 590081, metadata !55, metadata !"srcaddr", metadata !56, i32 12, metadata !60, i32 0} ; [ DW_TAG_arg_variable ]
!105 = metadata !{i32 590081, metadata !55, metadata !"len", metadata !56, i32 12, metadata !61, i32 0} ; [ DW_TAG_arg_variable ]
!106 = metadata !{i32 590080, metadata !107, metadata !"dest", metadata !56, i32 13, metadata !108, i32 0} ; [ DW_TAG_auto_variable ]
!107 = metadata !{i32 589835, metadata !55, i32 12, i32 0, metadata !56, i32 0} ; [ DW_TAG_lexical_block ]
!108 = metadata !{i32 589839, metadata !56, metadata !"", metadata !56, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !109} ; [ DW_TAG_pointer_type ]
!109 = metadata !{i32 589860, metadata !56, metadata !"char", metadata !56, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!110 = metadata !{i32 590080, metadata !107, metadata !"src", metadata !56, i32 14, metadata !111, i32 0} ; [ DW_TAG_auto_variable ]
!111 = metadata !{i32 589839, metadata !56, metadata !"", metadata !56, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !112} ; [ DW_TAG_pointer_type ]
!112 = metadata !{i32 589862, metadata !56, metadata !"", metadata !56, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !109} ; [ DW_TAG_const_type ]
!113 = metadata !{i32 590081, metadata !64, metadata !"dst", metadata !65, i32 12, metadata !69, i32 0} ; [ DW_TAG_arg_variable ]
!114 = metadata !{i32 590081, metadata !64, metadata !"src", metadata !65, i32 12, metadata !69, i32 0} ; [ DW_TAG_arg_variable ]
!115 = metadata !{i32 590081, metadata !64, metadata !"count", metadata !65, i32 12, metadata !70, i32 0} ; [ DW_TAG_arg_variable ]
!116 = metadata !{i32 590080, metadata !117, metadata !"a", metadata !65, i32 13, metadata !118, i32 0} ; [ DW_TAG_auto_variable ]
!117 = metadata !{i32 589835, metadata !64, i32 12, i32 0, metadata !65, i32 0} ; [ DW_TAG_lexical_block ]
!118 = metadata !{i32 589839, metadata !65, metadata !"", metadata !65, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !119} ; [ DW_TAG_pointer_type ]
!119 = metadata !{i32 589860, metadata !65, metadata !"char", metadata !65, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!120 = metadata !{i32 590080, metadata !117, metadata !"b", metadata !65, i32 14, metadata !121, i32 0} ; [ DW_TAG_auto_variable ]
!121 = metadata !{i32 589839, metadata !65, metadata !"", metadata !65, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !122} ; [ DW_TAG_pointer_type ]
!122 = metadata !{i32 589862, metadata !65, metadata !"", metadata !65, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !119} ; [ DW_TAG_const_type ]
!123 = metadata !{i32 590081, metadata !73, metadata !"destaddr", metadata !74, i32 11, metadata !78, i32 0} ; [ DW_TAG_arg_variable ]
!124 = metadata !{i32 590081, metadata !73, metadata !"srcaddr", metadata !74, i32 11, metadata !78, i32 0} ; [ DW_TAG_arg_variable ]
!125 = metadata !{i32 590081, metadata !73, metadata !"len", metadata !74, i32 11, metadata !79, i32 0} ; [ DW_TAG_arg_variable ]
!126 = metadata !{i32 590080, metadata !127, metadata !"dest", metadata !74, i32 12, metadata !128, i32 0} ; [ DW_TAG_auto_variable ]
!127 = metadata !{i32 589835, metadata !73, i32 11, i32 0, metadata !74, i32 0} ; [ DW_TAG_lexical_block ]
!128 = metadata !{i32 589839, metadata !74, metadata !"", metadata !74, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !129} ; [ DW_TAG_pointer_type ]
!129 = metadata !{i32 589860, metadata !74, metadata !"char", metadata !74, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!130 = metadata !{i32 590080, metadata !127, metadata !"src", metadata !74, i32 13, metadata !131, i32 0} ; [ DW_TAG_auto_variable ]
!131 = metadata !{i32 589839, metadata !74, metadata !"", metadata !74, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !132} ; [ DW_TAG_pointer_type ]
!132 = metadata !{i32 589862, metadata !74, metadata !"", metadata !74, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !129} ; [ DW_TAG_const_type ]
!133 = metadata !{i32 590081, metadata !82, metadata !"dst", metadata !83, i32 11, metadata !87, i32 0} ; [ DW_TAG_arg_variable ]
!134 = metadata !{i32 590081, metadata !82, metadata !"s", metadata !83, i32 11, metadata !88, i32 0} ; [ DW_TAG_arg_variable ]
!135 = metadata !{i32 590081, metadata !82, metadata !"count", metadata !83, i32 11, metadata !89, i32 0} ; [ DW_TAG_arg_variable ]
!136 = metadata !{i32 590080, metadata !137, metadata !"a", metadata !83, i32 12, metadata !138, i32 0} ; [ DW_TAG_auto_variable ]
!137 = metadata !{i32 589835, metadata !82, i32 11, i32 0, metadata !83, i32 0} ; [ DW_TAG_lexical_block ]
!138 = metadata !{i32 589839, metadata !83, metadata !"", metadata !83, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !139} ; [ DW_TAG_pointer_type ]
!139 = metadata !{i32 589877, metadata !83, metadata !"", metadata !83, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !140} ; [ DW_TAG_volatile_type ]
!140 = metadata !{i32 589860, metadata !83, metadata !"char", metadata !83, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!141 = metadata !{i32 21, i32 0, metadata !142, null}
!142 = metadata !{i32 589835, metadata !0, i32 20, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!143 = metadata !{i32 22, i32 0, metadata !142, null}
!144 = metadata !{i32 24, i32 0, metadata !142, null}
!145 = metadata !{i32 25, i32 0, metadata !142, null}
!146 = metadata !{i32 27, i32 0, metadata !142, null}
!147 = metadata !{i32 32, i32 0, metadata !148, null}
!148 = metadata !{i32 589835, metadata !22, i32 30, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!149 = metadata !{i32 34, i32 0, metadata !148, null}
!150 = metadata !{i32 35, i32 0, metadata !148, null}
!151 = metadata !{i32 13, i32 0, metadata !152, null}
!152 = metadata !{i32 589835, metadata !25, i32 12, i32 0, metadata !26, i32 0} ; [ DW_TAG_lexical_block ]
!153 = metadata !{i32 14, i32 0, metadata !152, null}
!154 = metadata !{i32 15, i32 0, metadata !152, null}
!155 = metadata !{i32 15, i32 0, metadata !95, null}
!156 = metadata !{i32 16, i32 0, metadata !95, null}
!157 = metadata !{i32 21, i32 0, metadata !158, null}
!158 = metadata !{i32 589835, metadata !40, i32 20, i32 0, metadata !41, i32 0} ; [ DW_TAG_lexical_block ]
!159 = metadata !{i32 27, i32 0, metadata !158, null}
!160 = metadata !{i32 29, i32 0, metadata !158, null}
!161 = metadata !{i32 16, i32 0, metadata !102, null}
!162 = metadata !{i32 17, i32 0, metadata !102, null}
!163 = metadata !{i32 19, i32 0, metadata !102, null}
!164 = metadata !{i32 22, i32 0, metadata !102, null}
!165 = metadata !{i32 25, i32 0, metadata !102, null}
!166 = metadata !{i32 26, i32 0, metadata !102, null}
!167 = metadata !{i32 28, i32 0, metadata !102, null}
!168 = metadata !{i32 29, i32 0, metadata !102, null}
!169 = metadata !{i32 32, i32 0, metadata !102, null}
!170 = metadata !{i32 20, i32 0, metadata !102, null}
!171 = metadata !{i32 15, i32 0, metadata !127, null}
!172 = metadata !{i32 16, i32 0, metadata !127, null}
!173 = metadata !{i32 17, i32 0, metadata !127, null}
