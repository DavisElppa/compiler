@str = constant [4 x i8] c"%f \00", align 1 ;预定义str，str1字符串,方便输出后续的浮点型数组
@str1 = constant [3 x i8] c"%d\00", align 1

define void @arr_set(float* %0, i32 %1) #0 {  ;%0寄存器为float数组p,%1表示数组长度变量n
  %3 = alloca float*, align 8 ;分配空间，对齐方式为8字节 
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store float* %0, float** %3, align 8 ;存入函数的参数值p,n
  store i32 %1, i32* %4, align 4
  %6 = call i64 @time(i64* null)  ;调用time函数，将时间作为随机数种子
  %7 = trunc i64 %6 to i32
  call void @srand(i32 %7) 
  store i32 0, i32* %5, align 4
  br label %8

8:                                             
  %9 = load i32, i32* %5, align 4
  %10 = load i32, i32* %4, align 4
  %11 = icmp slt i32 %9, %10
  br i1 %11, label %12, label %26

12:                                          
  %13 = call i32 @rand() 
  %14 = srem i32 %13, 1000
  %15 = sitofp i32 %14 to double
  %16 = fadd double %15, 1.000000e+00
  %17 = fdiv double %16, 1.000000e+03
  %18 = fptrunc double %17 to float
  %19 = load float*, float** %3, align 8
  %20 = load i32, i32* %5, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds float, float* %19, i64 %21
  store float %18, float* %22, align 4
  br label %23

23:                                               ; preds = %12
  %24 = load i32, i32* %5, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* %5, align 4
  br label %8

26:                                               ; preds = %8
  ret void
}

; Function Attrs: nounwind
declare  void @srand(i32) 

; Function Attrs: nounwind
declare  i64 @time(i64*) 

; Function Attrs: nounwind
declare  i32 @rand() 

; Function Attrs: noinline nounwind optnone uwtable
define  void @arr_print(float* %0, i32 %1) #0 {
  %3 = alloca float*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store float* %0, float** %3, align 8
  store i32 %1, i32* %4, align 4
  store i32 0, i32* %5, align 4
  br label %6

6:                                                ; preds = %10, %2
  %7 = load i32, i32* %5, align 4
  %8 = load i32, i32* %4, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %10, label %20

10:                                               ; preds = %6
  %11 = load float*, float** %3, align 8
  %12 = load i32, i32* %5, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds float, float* %11, i64 %13
  %15 = load float, float* %14, align 4
  %16 = fpext float %15 to double
  %17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str, i64 0, i64 0), double %16)
  %18 = load i32, i32* %5, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, i32* %5, align 4
  br label %6

20:                                               ; preds = %6
  ret void
}

declare  i32 @printf(i8*, ...) 

; Function Attrs: noinline nounwind optnone uwtable
define  i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca float*, align 8
  store i32 0, i32* %1, align 4
  %4 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str1, i64 0, i64 0), i32* %2)
  store float* null, float** %3, align 8
  %5 = load i32, i32* %2, align 4
  %6 = sext i32 %5 to i64
  %7 = mul i64 4, %6
  %8 = call noalias i8* @malloc(i64 %7) 
  %9 = bitcast i8* %8 to float*
  store float* %9, float** %3, align 8
  %10 = load float*, float** %3, align 8
  %11 = load i32, i32* %2, align 4
  call void @arr_set(float* %10, i32 %11)
  %12 = load float*, float** %3, align 8
  %13 = load i32, i32* %2, align 4
  call void @arr_print(float* %12, i32 %13)
  ret i32 0
}

declare  i32 @__isoc99_scanf(i8*, ...)

; Function Attrs: nounwind
declare  noalias i8* @malloc(i64)


